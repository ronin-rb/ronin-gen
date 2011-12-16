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

        # Default authors to use
        DEFAULT_AUTHOR = 'Anonymous'

        data_dir File.join('ronin','gen','repository')

        parameter :title, :type => String
        parameter :uri, :type => String
        parameter :source, :type => String
        parameter :website, :type => String

        parameter :license, :type    => String,
                            :default => 'CC-by'

        parameter :description, :type    => String,
                                :default => 'This is a Ronin Repository'

        parameter :authors, :type    => Array[String],
                            :default => []

        parameter :tests, :type => true
        parameter :docs, :type => true

        def setup
          @title   ||= File.basename(@path).gsub(/[_\s]+/,' ').capitalize
          @website ||= @source

          if @authors.empty?
            @authors << DEFAULT_AUTHOR
          end
        end

        #
        # Generates a skeleton repository.
        #
        def generate
          template 'ronin.yml.erb', 'ronin.yml'
          template 'Rakefile.erb', 'Rakefile'

          mkdir LIB_DIR
          mkdir File.join(LIB_DIR,'ronin')
          touch File.join(LIB_DIR,Ronin::Repository::INIT_FILE)

          mkdir SCRIPT_DIR
          mkdir Ronin::Repository::DATA_DIR

          if docs?
            template '.yardopts.erb', '.yardopts'
          end

          if tests?
            cp '.rspec'

            mkdir 'spec'
            cp File.join('spec','spec_helper.rb')
          end
        end

      end
    end
  end
end
