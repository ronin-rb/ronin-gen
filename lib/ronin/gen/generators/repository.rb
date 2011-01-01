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
        class_option :license, :type => :string, :default => DEFAULT_LICENSE
        class_option :description, :type => :string, :default => DEFAULT_DESCRIPTION
        class_option :authors, :type => :array, :default => DEFAULT_AUTHORS, :banner => 'NAME [...]'
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

          mkdir Ronin::Repository::DATA_DIR
          mkdir Ronin::Repository::CACHE_DIR
        end

        #
        # Generates the Rakefile of the repository.
        #
        def rakefile
          erb File.join('ronin','gen','repository','Rakefile.erb'), 'Rakefile'
        end

        #
        # Generates a base RSpec test-suite for the repository.
        #
        def tests
          cp File.join('ronin','gen','repository','.rspec'), '.rspec'

          mkdir 'spec'
          cp File.join('ronin','gen','repository','spec','spec_helper.rb'),
             File.join('spec','spec_helper.rb')
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
