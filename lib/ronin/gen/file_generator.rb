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

require 'ronin/gen/generator'

module Ronin
  module Gen
    #
    # A {Generator} class for creating files.
    #
    class FileGenerator < Generator

      argument :path, :type => :string, :require => true

      #
      # Generates the file at the given path.
      #
      def self.generate(options={},arguments=[])
        super(options,arguments) do |gen|
          if (self.file_extension && File.extname(gen.path).empty?)
            gen.path += ".#{self.file_extension}"
          end

          yield gen if block_given?
        end
      end

      protected

      #
      # The file extension to append to all paths.
      #
      # @return [String, nil]
      #   The file extension.
      #
      # @since 1.0.0
      #
      def self.file_extension
        @file_extension
      end

      #
      # Sets the file extension to append to all paths.
      #
      # @param [String] ext
      #   The file extension.
      #
      # @since 1.0.0
      #
      def self.file_extension!(ext)
        @file_extension = ext.to_s
      end

    end
  end
end
