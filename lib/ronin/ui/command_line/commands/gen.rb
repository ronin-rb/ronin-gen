#
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
#

require 'ronin/generators/version'
require 'ronin/ui/command_line/command'
require 'ronin/ui/command_line/command_line'

module Ronin
  module UI
    module CommandLine
      module Commands
        class Gen < Command

          desc "version", "Prints the version and exists"
          def version
            puts "Ronin Gen #{Ronin::Generators::VERSION}"
            exit
          end

          desc "default", "Prints the list of available generators"
          def default
            puts CommandLine.commands.map { |name|
              if name =~ /^gen_/
                name.gsub(/^gen_/,'  ')
              else
                nil
              end
            }.compact.sort
          end

        end
      end
    end
  end
end
