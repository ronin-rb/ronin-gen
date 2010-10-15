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
      # @since 0.3.0
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
      # @since 0.3.0
      #
      def self.file_extension!(ext)
        @file_extension = ext.to_s
      end

    end
  end
end
