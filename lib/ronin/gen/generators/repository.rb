#
# Copyright (c) 2009-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin Gen.
#
# Ronin Gen is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin Gen is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin Gen.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/gen/config'
require 'ronin/gen/dir_generator'
require 'ronin/repository'
require 'ronin/version'

require 'set'

module Ronin
  module Gen
    module Generators
      #
      # Generates a completely new Ronin Repository.
      #
      class Repository < DirGenerator

        # The repository metadata file
        METADATA_FILE = Ronin::Repository::METADATA_FILE

        # The repository lib directory
        LIB_DIR = Ronin::Repository::LIB_DIR

        # The primary script directory
        SCRIPT_DIR = Ronin::Repository::SCRIPT_DIRS.first

        # Default license to use
        DEFAULT_LICENSE = 'CC-by'

        # Default authors to use
        DEFAULT_AUTHORS = ['Anonymous']

        # Default description to use
        DEFAULT_DESCRIPTION = 'This is a Ronin Repository'

        desc 'Generates a new Ronin Repository'
        class_option :title, :type => :string
        class_option :uri, :type => :string
        class_option :source, :type => :string
        class_option :website, :type => :string

        class_option :license, :type => :string,
                               :default => DEFAULT_LICENSE,
                               :banner => 'LICENSE'

        class_option :description, :type => :string,
                                   :default => DEFAULT_DESCRIPTION,
                                   :banner => 'TEXT'

        class_option :authors, :type => :array,
                               :default => DEFAULT_AUTHORS,
                               :banner => 'NAME [...]'

        class_option :tests, :type => :boolean
        class_option :docs, :type => :boolean

        def setup
          @title = options[:title]
          @uri = options[:uri]
          @source = options[:source]
          @website = options[:website]
          @license = options[:license]
          @description = options[:description]
          @authors = options[:authors]

          @test_suite = options[:test]
          @docs = options[:docs]

          @title ||= File.basename(self.path).gsub(/[_\s]+/,' ').capitalize
          @website ||= @source
        end

        #
        # Generates a skeleton repository.
        #
        def generate
          mkdir LIB_DIR
          mkdir File.join(LIB_DIR,'ronin')
          touch File.join(LIB_DIR,Ronin::Repository::INIT_FILE)

          mkdir SCRIPT_DIR
          mkdir Ronin::Repository::DATA_DIR
        end

        #
        # Generates the Rakefile of the repository.
        #
        def rakefile
          erb File.join('ronin','gen','repository','Rakefile.erb'),
              'Rakefile'
        end

        #
        # Generates a base RSpec test-suite for the repository.
        #
        def tests
          if options.tests?
            cp File.join('ronin','gen','repository','.rspec'), '.rspec'

            mkdir 'spec'
            cp File.join('ronin','gen','repository','spec','spec_helper.rb'),
               File.join('spec','spec_helper.rb')
          end
        end

        #
        # Generate files needed for documentation.
        #
        def docs
          if options.docs?
            erb File.join('ronin','gen','repository','.yardopts.erb'),
                '.yardopts'
          end
        end

        #
        # Generates the XML metadata file for the repository.
        #
        def metadata
          erb File.join('ronin','gen','repository','ronin.yml.erb'),
              'ronin.yml'
        end

      end
    end
  end
end
