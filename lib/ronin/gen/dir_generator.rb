#
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
#

require 'ronin/gen/generator'

require 'fileutils'

module Ronin
  module Gen
    class DirGenerator < Generator

      argument :path, :type => :string, :require => true

      #
      # Invokes the generator.
      #
      # @param [String] path
      #   The directory to generate within.
      #
      # @param [Hash] options
      #   Additional command-line options for the generator.
      #
      # @param [Array] arguments
      #   Additional command-line arguments for the generator.
      #
      # @example
      #   gen.generate('path/to/dir')
      #
      def self.generate(path,options={},arguments=[])
        path = File.expand_path(path)

        generator = self.new([path] + arguments, options)
        generator.invoke()
      end

      protected

      #
      # Initializes the generator.
      #
      # @param [Array] arguments
      #   Additional arguments for the generator.
      #
      # @param [Hash] options
      #   Options to pass to the generator.
      #
      # @param [Hash] config
      #   Additional configuration for the generator.
      #
      # @since 0.2.2
      #
      def initialize(arguments=[],options={},config={})
        super(arguments,options,config) do |gen|
          gen.destination_root = self.path
        end
      end

    end
  end
end
