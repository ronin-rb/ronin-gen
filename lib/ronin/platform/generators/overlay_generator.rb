#
#--
# Ronin Gen - A Ruby library for Ronin that provides various Generators for
# Ronin.
#
# Copyright (c) 2009 Postmodern (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#++
#

require 'ronin/platform/overlay'

require 'nokogiri'
require 'fileutils'
require 'set'

module Ronin
  module Platform
    module Generators
      class OverlayGenerator

        include Nokogiri

        # Title of the overlay
        attr_accessor :title

        # Source URL for the overlay
        attr_accessor :source

        # Source View URL for the overlay
        attr_accessor :source_view

        # Website of the overlay
        attr_accessor :website

        # License of the overlay
        attr_accessor :license

        # Maintainers of the overlay
        attr_reader :maintainers

        # Description of the overlay
        attr_accessor :description

        # Tasks to require for the overlay
        attr_reader :tasks

        #
        # Creates a new Metadata object with the given _options_.
        #
        # _options_ may include the following keys:
        # <tt>:title</tt>:: Title for the overlay.
        # <tt>:source</tt>:: Source URL for the overlay.
        # <tt>:source_view</tt>:: Source View URL for the overlay.
        # <tt>:website</tt>:: Website for the overlay.
        # <tt>:license</tt>:: License for the overlay.
        # <tt>:maintainers</tt>:: List of maintainers for the overlay.
        # <tt>:description</tt>:: The description of the overlay.
        #
        def initialize(options={})
          @title = options[:title]
          @source = options[:source]
          @source_view = options[:source_view]
          @website = options[:website]
          @license = options[:license]
          @maintainers = []
          
          if options[:maintainers]
            @maintainers.merge!(options[:maintainers])
          end

          @description = options[:description]
          @tasks = Set[]

          if options[:tasks]
            @tasks.merge!(options[:tasks])
          end
        end

        #
        # Adds a new maintainer with the specified _name_ and _email_.
        #
        def maintainer(name,email)
          @maintainers << {:name => name, :email => email}
        end

        #
        # Generates the Overlay metadata file for the Overlay at the
        # specified _path_.
        #
        def generate(path)
          @title ||= File.basename(path).gsub(/[_\s]+/,' ').capitalize
          @source_view ||= @source
          @website ||= @source_view

          FileUtils.mkdir_p(path)
          FileUtils.mkdir_p(File.join(path,'lib'))
          FileUtils.mkdir_p(File.join(path,'tasks'))
          FileUtils.mkdir_p(File.join(path,'objects'))

          File.open(File.join(path,'Rakefile'),'w') do |file|
            file << "# -*- ruby -*-\n\n"

            @tasks.each do |task|
              file << "require 'ronin/platform/tasks/#{task}'"
            end

            file << "\n# vim: syntax=Ruby"
          end

          File.open(File.join(path,Overlay::METADATA_FILE),'w') do |file|
            doc = XML::Document.new
            doc << XML::ProcessingInstruction.new(
              doc,
              'xml-stylesheet',
              'type="text/xsl" href="http://ronin.rubyforge.org/dist/overlay.xsl"'
            )

            root = XML::Node.new('ronin-overlay',doc)
            root['version'] = Ronin::VERSION

            title_tag = XML::Node.new('title',doc)
            title_tag << XML::Text.new(@title,doc)
            root << title_tag

            if @source
              source_tag = XML::Node.new('source',doc)
              source_tag << XML::Text.new(@source,doc)
              root << source_tag
            end

            if @source_view
              source_view_tag = XML::Node.new('source-view',doc)
              source_view_tag << XML::Text.new(@source_view,doc)
              root << source_view_tag
            end

            if @website
              url_tag = XML::Node.new('website',doc)
              url_tag << XML::Text.new(@website,doc)
              root << url_tag
            end

            if @license
              license_tag = XML::Node.new('license',doc)
              license_tag << XML::Text.new(@license,doc)
              root << license_tag
            end

            unless @maintainers.empty?
              maintainers_tag = XML::Node.new('maintainers',doc)

              @maintainers.each do |author|
                if (author[:name] || author[:email])
                  maintainer_tag = XML::Node.new('maintainer',doc)

                  if author[:name]
                    name_tag = XML::Node.new('name',doc)
                    name_tag << XML::Text.new(author[:name],doc)
                    maintainer_tag << name_tag
                  end

                  if author[:email]
                    email_tag = XML::Node.new('email',doc)
                    email_tag << XML::Text.new(author[:email],doc)
                    maintainer_tag << email_tag
                  end

                  maintainers_tag << maintainer_tag
                end
              end

              root << maintainers_tag
            end

            if @description
              description_tag = XML::Node.new('description',doc)
              description_tag << XML::Text.new(@description,doc)
              root << description_tag
            end

            doc << root
            doc.write_xml_to(file)
          end
        end

      end
    end
  end
end
