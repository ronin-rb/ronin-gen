#
#--
# Ronin Gen - A Ruby library for Ronin that provides various generators.
#
# Copyright (c) 2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/generators/dir_generator'
require 'ronin/platform/extension'

module Ronin
  module Platform
    module Generators
      class Extension < DirGenerator

        # The default extension file
        EXTENSION_FILE = File.join('ronin','platform','generators','extension.rb')

        protected

        #
        # Generates a skeleton Extension.
        #
        def generate!
          name = File.basename(@path)
          lib_dir = Platform::Extension::LIB_DIR

          directory lib_dir
          file File.join(lib_dir,name + '.rb')
          directory File.join(lib_dir,name)

          copy EXTENSION_FILE, Platform::Extension::EXTENSION_FILE
        end

      end
    end
  end
end
