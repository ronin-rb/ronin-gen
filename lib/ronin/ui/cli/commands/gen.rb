#
# Copyright (c) 2009-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/ui/cli/command'
require 'ronin/gen/gen'
require 'ronin/gen/version'

require 'parameters/options'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # The `ronin-gen` command.
        #
        class Gen < Command

          summary "Prints the list of available generators"

          usage '[options] | GENERATOR [generator-options]'

          option :version, :type => true,
                           :flag => '-V',
                           :description => 'Prints the ronin-gen version'

          #
          # Starts the `ronin-gen` command.
          #
          # @param [Array<String>] argv
          #   The arguments for the command.
          #
          def start(argv=ARGV)
            if (argv.empty? || argv.first.start_with?('-'))
              return super(argv)
            end

            generator_name = argv.shift
            generator      = Ronin::Gen.generator(generator_name).new

            opts = Parameters::Options.parser(generator) do |opts|
              opts.banner = "ronin-gen #{generator_name} PATH [options]"
            end

            args = opts.parse(argv)

            generator.path = args.first
            generator.generate!
          end

          #
          # Lists the available generators.
          #
          def execute
            if version?
              puts "ronin-gen #{Ronin::Gen::VERSION}"
              return
            end

            print_array Ronin::Gen.generators, :title => 'Available Generators'
          end

        end
      end
    end
  end
end
