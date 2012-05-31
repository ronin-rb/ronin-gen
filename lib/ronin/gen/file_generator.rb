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

require 'ronin/gen/generator'

module Ronin
  module Gen
    #
    # A {Generator} class for creating files.
    #
    class FileGenerator < Generator

      # The file to generate
      attr_accessor :path

      #
      # Initializes the file generator.
      #
      # @param [String] path
      #   The path to the file to be generated.
      #
      # @param [Hash{Symbol => Object}] options
      #   Additional options for the generator.
      #
      # @yield [generator]
      #   The given block will be passed the newly created generator.
      #
      # @yieldparam [FileGenerator]
      #   The newly created generator.
      #
      # @api semipublic
      #
      # @since 1.2.0
      #
      def initialize(path=nil,options={},&block)
        @path = path

        super(options,&block)
      end

      #
      # Sets up the generator and calls {#generate}.
      #
      # @raise [RuntimeError]
      #   {#path} was not set.
      #
      # @since 1.2.0
      #
      # @api public
      #
      def generate!
        unless @path
          raise("#{self.class}#path was not set")
        end

        super
      end

      #
      # Sets up the File generator.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      def setup
        if (self.class.file_extension && File.extname(@path).empty?)
          @path += ".#{self.class.file_extension}"
        end
      end

      protected

      #
      # The file extension to append to all paths.
      #
      # @param [String] ext
      #   The new file extension to use.
      #
      # @return [String, nil]
      #   The file extension.
      #
      # @since 1.0.0
      #
      # @api semipublic
      #
      def self.file_extension(ext=nil)
        if ext
          @file_extension = ext.to_s
        else
          @file_extension ||= if superclass < FileGenerator
                                superclass.file_extension
                              end
        end
      end

    end
  end
end
