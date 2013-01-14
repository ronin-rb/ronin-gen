#
# Copyright (c) 2009-2013 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/gen/ruby_generator'

module Ronin
  module Gen
    module Generators
      #
      # A {RubyGenerator} class for creating executable Ruby scripts.
      #
      # @since 1.3.0
      #
      class Script < RubyGenerator

        data_dir File.join('ronin/gen')

        template 'script.rb.erb'

        #
        # Generates a new Ruby script.
        #
        def generate
          super

          chmod 0755, @path
        end

      end
    end
  end
end
