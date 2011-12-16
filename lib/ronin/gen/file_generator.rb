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

      # The destination path for the generator
      parameter :path, :type        => String,
                       :description => 'File to generate'

      #
      # Invokes the new File Generator.
      #
      # @param [String] path
      #   The path for the generator.
      #
      # @param [Hash{Symbol => Object}] options
      #   Additional options for the generator.
      #
      # @api public
      #
      def self.generate(path,options={})
        super(options.merge(:path => path))
      end

      #
      # Sets up the File generator.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      def setup
        require_params :path

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
