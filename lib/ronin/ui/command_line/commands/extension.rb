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

require 'ronin/ui/command_line/command'
require 'ronin/platform/generators/extension'

module Ronin
  module UI
    module CommandLine
      module Commands
        class Extension < Command

          def defaults
            @generator = Platform::Generators::Extension.new
          end

          def define_options(opts)
            opts.usage = 'PATH [...]'

            opts.arguments(
              'PATH' => 'The PATH of the Extension to be created'
            )

            opts.summary('Create an empty Extension at the specified PATH')
          end

          def arguments(*args)
            args.each do |path|
              @generator.run(File.expand_path(path))
            end
          end

        end
      end
    end
  end
end
