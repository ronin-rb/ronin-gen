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

require 'ronin/gen/exceptions/unknown_generator'
require 'ronin/gen/generators'
require 'ronin/installation'

require 'set'

module Ronin
  module Gen
    # The loaded generator names
    @generators = SortedSet[]

    #
    # Loads the generator with the given name.
    #
    # @param [String] name
    #   The colon separated name of the generator.
    #
    # @return [Generator, nil]
    #   The loaded generator. If `nil` is returned, then the generator
    #   could not be found.
    #
    # @raise [UnknownGenerator]
    #   The generator could not be found or loaded.
    #
    # @example
    #   Gen.generator 'library'
    #   # => Ronin::Gen::Generators::Library
    #
    # @example Load a generator within a namespace
    #   Gen.generator 'exploits:remote_tcp'
    #   # => Ronin::Gen::Generators::Exploits::RemoteTcp
    #
    # @since 1.0.0
    #
    def Gen.generator(name)
      name = name.to_s

      unless (generator = Generators.require_const(name))
        raise(UnknownGenerator,"unknown generator #{name.dump}")
      end

      return generator
    end

    #
    # The names of all available generators.
    #
    # @return [Hash]
    #   The names and paths of all installed generators.
    #
    # @since 0.3.0
    #
    def Gen.generators
      if @generators.empty?
        directory = File.join('lib',Generators.namespace_root)

        Installation.each_file_in(directory,:rb) do |path|
          # strip the tailing '.rb' file extension
          name = path.chomp('.rb')

          # replace any file separators with a ':', to mimic the
          # naming convention of Rake/Thor.
          name.tr!(File::SEPARATOR,':')

          @generators << name
        end
      end

      return @generators
    end
  end
end
