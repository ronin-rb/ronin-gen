#
# Ronin Gen - A Ruby library for Ronin that provides various generators.
#
# Copyright (c) 2009-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#

require 'ronin/gen/config'
require 'ronin/gen/dir_generator'
require 'ronin/platform/overlay'
require 'ronin/version'

require 'nokogiri'
require 'set'

module Ronin
  module Gen
    module Generators
      #
      # Generates a completely new Ronin Overlay.
      #
      class Overlay < DirGenerator

        include Nokogiri

        # The Overlay Format Version
        FORMAT_VERSION = Ronin::Platform::Overlay::FORMAT_VERSION

        # The Overlay metadata file
        METADATA_FILE = Ronin::Platform::Overlay::METADATA_FILE

        # The Overlay metadata XSL URL
        METADATA_XSL = 'overlay.xsl'

        # The Overlay lib directory
        LIB_DIR = Ronin::Platform::Overlay::LIB_DIR

        # Default license to use
        DEFAULT_LICENSE = 'CC-by'

        # Default maintainer to use
        DEFAULT_MAINTAINER = {'Name' => 'name@example.com'}

        # Default description to use
        DEFAULT_DESCRIPTION = 'This is an Overlay'

        desc 'Generates a new Ronin Overlay'
        class_option :title, :type => :string
        class_option :uri, :type => :string
        class_option :source, :type => :string
        class_option :website, :type => :string
        class_option :license, :type => :string, :default => DEFAULT_LICENSE
        class_option :description, :type => :string, :default => DEFAULT_DESCRIPTION
        class_option :maintainers, :type => :hash, :default => {}, :banner => 'NAME:EMAIL ...'
        class_option :gems, :type => :array, :default => [], :banner => 'GEM ...'
        class_option :tasks, :type => :array, :default => [], :banner => 'TASK ...'
        class_option :test_suite, :type => :string, :banner => 'unit|rspec'
        class_option :docs, :type => :boolean

        def setup
          @title = options[:title]
          @uri = options[:uri]
          @source = options[:source]
          @website = options[:website]
          @license = options[:license]
          @description = options[:description]
          @maintainers = options[:maintainers]
          @gems = options[:gems]
          @tasks = options[:tasks]
          @test_suite = options[:test_suite]
          @docs = options[:docs]

          @title ||= File.basename(self.path).gsub(/[_\s]+/,' ').capitalize
          @website ||= @source

          if @maintainers
            @maintainers = DEFAULT_MAINTAINER
          end
        end

        #
        # Generates a skeleton Overlay.
        #
        def generate
          mkdir LIB_DIR
          touch File.join(LIB_DIR,Ronin::Platform::Overlay::INIT_FILE)

          mkdir 'data'
          cp File.join('ronin','platform',METADATA_XSL), File.join('data',METADATA_XSL)

          mkdir Ronin::Platform::Overlay::CACHE_DIR
          mkdir Ronin::Platform::Overlay::EXTS_DIR

          mkdir 'tasks'
        end

        #
        # Generates the Rakefile of the Overlay.
        #
        def rakefile
          case @test_suite
          when 'rspec', 'spec'
            @tasks << './tasks/spec.rb'
          end

          if @docs
            @tasks << './tasks/yard.rb'
          end

          erb File.join('ronin','gen','platform','Rakefile.erb'), 'Rakefile'
        end

        #
        # Generates a base test suite for the Overlay.
        #
        def test_suite
          case @test_suite
          when 'test','unit'
            mkdir 'test'
          when 'rspec', 'spec'
            cp File.join('ronin','gen','platform','tasks','spec.rb'), File.join('tasks','spec.rb')

            mkdir 'spec'
            cp File.join('ronin','gen','platform','spec','spec_helper.rb'), File.join('spec','spec_helper.rb')
          end
        end

        #
        # Generate the YARD documentation generation task.
        #
        def docs
          if @docs
            erb File.join('ronin','gen','platform','tasks','yard.rb.erb'), File.join('tasks','yard.rb')
          end
        end

        #
        # Generates the XML metadata file for the Overlay.
        #
        def metadata
          create_file(METADATA_FILE) do
            doc = XML::Document.new
            doc << XML::ProcessingInstruction.new(
              doc,
              'xml-stylesheet',
              "type=\"text/xsl\" href=\"data/#{METADATA_XSL}\""
            )

            root = XML::Node.new('ronin-overlay',doc)
            root['version'] = FORMAT_VERSION.to_s

            title_tag = XML::Node.new('title',doc)
            title_tag << XML::Text.new(@title,doc)
            root << title_tag

            if @uri
              uri_tag = XML::Node.new('uri',doc)
              uri_tag << XML::Text.new(@uri,doc)
              root << uri_tag
            end

            if @source
              source_tag = XML::Node.new('source',doc)
              source_tag << XML::Text.new(@source,doc)
              root << source_tag
            end

            if @website
              website_tag = XML::Node.new('website',doc)
              website_tag << XML::Text.new(@website,doc)
              root << website_tag
            end

            license_tag = XML::Node.new('license',doc)
            license_tag << XML::Text.new(@license,doc)
            root << license_tag

            maintainers_tag = XML::Node.new('maintainers',doc)

            @maintainers.each do |name,email|
              maintainer_tag = XML::Node.new('maintainer',doc)

              if name
                name_tag = XML::Node.new('name',doc)
                name_tag << XML::Text.new(name,doc)
                maintainer_tag << name_tag
              end

              if email
                email_tag = XML::Node.new('email',doc)
                email_tag << XML::Text.new(email,doc)
                maintainer_tag << email_tag
              end

              maintainers_tag << maintainer_tag
            end

            root << maintainers_tag

            unless @gems.empty?
              dependencies_tag = XML::Node.new('dependencies',doc)
              dependencies_tag << XML::Text.new(gems_tag,doc)

              @gems.each do |gem_name|
                gem_tag = XML::Node.new('gem',doc)
                gem_tag << XML::Text.new(gem_name,doc)
                dependencies_tag << gem_tag
              end

              root << dependencies_tag
            end

            description_tag = XML::Node.new('description',doc)
            description_tag << XML::Text.new(@description,doc)
            root << description_tag

            doc << root
            doc.to_xml
          end
        end

      end
    end
  end
end
