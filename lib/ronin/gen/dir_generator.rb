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

require 'fileutils'

module Ronin
  module Gen
    #
    # A {Generator} class for creating directories.
    #
    class DirGenerator < Generator

      # The directory to generate
      attr_accessor :path

      #
      # Initializes the directory generator.
      #
      # @param [String] path
      #   The path to the directory to be generated.
      #
      # @param [Hash{Symbol => Object}] options
      #   Additional options for the generator.
      #
      # @yield [generator]
      #   The given block will be passed the newly created generator.
      #
      # @yieldparam [DirGenerator]
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
      # Creates the directory and invokes the generator.
      #
      # @raise [RuntimeError]
      #   {#path} was not set.
      #
      # @api semipublic
      #
      # @since 1.1.0
      #
      def generate!
        unless @path
          raise("#{self.class}#path was not set")
        end

        FileUtils.mkdir_p(@path)
        FileUtils.chdir(@path) { super }
      end

      protected

      #
      # Changes current working directory, relative to the generated directory.
      #
      # @param [String] path
      #   The path within the generated directory to switch to.
      #
      # @yield []
      #   The given block will be ran after the current working directory
      #   has been changed. After the block has returned, the current working
      #   directory will be changed back.
      #
      # @since 1.1.0
      #
      # @see http://rubydoc.info/stdlib/core/Dir#chdir-class_method
      #
      def chdir(path='.')
        super(File.join(@path,path),&block)
      end

    end
  end
end
