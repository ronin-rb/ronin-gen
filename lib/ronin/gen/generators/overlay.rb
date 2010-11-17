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
require 'ronin/overlay'
require 'ronin/version'

require 'set'

module Ronin
  module Gen
    module Generators
      #
      # Generates a completely new Ronin Overlay.
      #
      class Overlay < DirGenerator

        # The Overlay metadata file
        METADATA_FILE = Ronin::Overlay::METADATA_FILE

        # The Overlay lib directory
        LIB_DIR = Ronin::Overlay::LIB_DIR

        # Default license to use
        DEFAULT_LICENSE = 'CC-by'

        # Default authors to use
        DEFAULT_AUTHORS = {'Name' => 'name@example.com'}

        # Default description to use
        DEFAULT_DESCRIPTION = 'This is an Overlay'

        desc 'Generates a new Ronin Overlay'
        class_option :title, :type => :string
        class_option :uri, :type => :string
        class_option :source, :type => :string
        class_option :website, :type => :string
        class_option :license, :type => :string, :default => DEFAULT_LICENSE
        class_option :description, :type => :string, :default => DEFAULT_DESCRIPTION
        class_option :authors, :type => :hash, :default => DEFAULT_AUTHORS, :banner => 'NAME:EMAIL ...'
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
          @authors = options[:authors]
          @gems = options[:gems]
          @tasks = options[:tasks]
          @test_suite = options[:test_suite]
          @docs = options[:docs]

          @title ||= File.basename(self.path).gsub(/[_\s]+/,' ').capitalize
          @website ||= @source
        end

        #
        # Generates a skeleton Overlay.
        #
        def generate
          mkdir LIB_DIR
          mkdir File.join(LIB_DIR,'ronin')
          touch File.join(LIB_DIR,Ronin::Overlay::INIT_FILE)

          mkdir Ronin::Overlay::DATA_DIR
          mkdir Ronin::Overlay::CACHE_DIR

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

          erb File.join('ronin','gen','overlay','Rakefile.erb'), 'Rakefile'
        end

        #
        # Generates a base test suite for the Overlay.
        #
        def test_suite
          case @test_suite
          when 'test','unit'
            mkdir 'test'
          when 'rspec', 'spec'
            cp File.join('ronin','gen','overlay','tasks','spec.rb'),
               File.join('tasks','spec.rb')

            mkdir 'spec'
            cp File.join('ronin','gen','overlay','spec','spec_helper.rb'),
               File.join('spec','spec_helper.rb')
          end
        end

        #
        # Generate the YARD documentation generation task.
        #
        def docs
          if @docs
            erb File.join('ronin','gen','overlay','tasks','yard.rb.erb'),
                File.join('tasks','yard.rb')
          end
        end

        #
        # Generates the XML metadata file for the Overlay.
        #
        def metadata
          erb File.join('ronin','gen','overlay','overlay.yml.erb'),
              'overlay.yml'
        end

      end
    end
  end
end
