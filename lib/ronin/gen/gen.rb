#
# Ronin Gen - A Ruby library for Ronin that provides various generators.
#
# Copyright (c) 2009-2010 Hal Brodigan (postmodern.mod3 at example.com)
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

require 'ronin/gen/exceptions/unknown_generator'
require 'ronin/extensions/kernel'
require 'ronin/ronin'

module Ronin
  module Gen
    GENERATORS_DIR = File.join('ronin','gen','generators')

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
    # @example
    #   Gen.generator 'library'
    #   # => Ronin::Gen::Generators::Library
    #
    # @example Load a generator within a namespace
    #   Gen.generator 'exploits:remote_tcp'
    #   # => Ronin::Gen::Generators::Exploits::RemoteTcp
    #
    # @since 0.3.0
    #
    def Gen.generator(name)
      name = name.to_s

      dirs = name.gsub(/[_-]+/,'_').split(':')
      path = File.join(*dirs)

      unless (generator = require_const_in(GENERATORS_DIR,path))
        raise(UnknownGenerator,"unknown generator #{name.dump}",caller)
      end

      return generator
    end

    #
    # The names of all available generators.
    #
    # @return [SortedSet<String>]
    #   The names of all installed generators.
    #
    # @since 0.3.0
    #
    def Gen.generators
      unless class_variable_defined?('@@ronin_gen_generators')
        @@ronin_gen_generators = SortedSet[]

        pattern = File.join('lib',GENERATORS_DIR,'**','*.rb')

        Ronin.find_files(pattern).each do |path|
          sub_path = path.match(File.join(GENERATORS_DIR,"(.*)$"))

          if (sub_path && sub_path[1])
            name = sub_path[1].split(File::SEPARATOR).join(':')
            @@ronin_gen_generators << name
          end
        end
      end

      return @@ronin_gen_generators
    end
  end
end
