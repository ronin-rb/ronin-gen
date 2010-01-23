#
# Ronin Gen - A Ruby library for Ronin that provides various generators.
#
# Copyright (c) 2009 Hal Brodigan (postmodern.mod3 at example.com)
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

require 'ronin/templates/template'

require 'static_paths/finders'
require 'extlib'
require 'erb'
require 'thor'

module Ronin
  module Generators
    class Generator < Thor::Group

      include Thor::Actions
      include Templates::Template
      include StaticPaths::Finders

      def self.inherited(super_class)
        class_name = super_class.name.split('::').last.snake_case
        super_class.namespace("ronin #{class_name}")
      end

      #
      # Defines the default source root of the generator as the current
      # working directory.
      #
      # @since 0.2.0
      #
      def self.source_root
        @generator_source_root ||= Dir.pwd
      end

      #
      # Sets the source root of the generator.
      #
      # @param [String] new_dir
      #   The new source root directory.
      #
      # @return [String]
      #   The source root directory of the generator.
      #
      # @since 0.2.2
      #
      def self.source_root=(new_dir)
        @genereator_source_root = File.expand_path(new_dir)
      end

      #
      # Invokes the generator.
      #
      # @param [Hash] options
      #   Class options to use with the generator.
      #
      # @param [Array] arguments
      #   Additional arguments for the generator.
      #
      # @example
      #   gen.generate
      #
      # @since 0.2.0
      #
      def self.generate(options={},arguments=[])
        generator = self.new(arguments, options)
        generator.invoke()
      end

      desc "default generator task"

      #
      # Default generator method.
      #
      # @since 0.2.0
      #
      def generate
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
      def initialize(arguments=[],options={},config={},&block)
        super(arguments,options,config)

        defaults()
        block.call(self) if block
      end

      #
      # Default method to initialize any instance variables before any of
      # the tasks are invoked.
      #
      # @since 0.2.2
      #
      def defaults
      end

      #
      # Touches a file.
      #
      # @param [String] destination
      #   The relative path to the file to touch.
      #
      # @example
      #   touch 'TODO.txt'
      #
      # @since 0.2.0
      #
      def touch(destination)
        create_file(destination)
      end

      #
      # Creates an empty directory.
      #
      # @param [String] destination
      #   The relative path of the directory to create.
      #
      # @example
      #   directory 'sub/dir'
      #
      # @since 0.2.0
      #
      def mkdir(destination)
        empty_directory(destination)
      end

      #
      # Copies a static-file.
      #
      # @param [String] static_file
      #   The relative path to the static file.
      #
      # @param [String] destination
      #   The destination to copy the static file to.
      #
      # @example
      #   copy_file 'ronin/platform/generators/extension.rb',
      #             'myext/extension.rb'
      #
      # @since 0.2.0
      #
      def copy_file(static_file,destination)
        super(find_static_file(static_file),destination)
      end

      #
      # Renders the ERB template at the specified _template_path_ and
      # saves the result at the given _destination_.
      #
      # @param [String] template_path
      #   The relative path to the template.
      #
      # @param [String, nil] destination
      #   The destination to write the result of the rendered template to.
      #
      # @return [nil, String]
      #   If destination is +nil+, the result of the rendered template
      #   will be returned.
      #
      # @example
      #   template 'ronin/platform/generators/Rakefile.erb', 'Rakefile.erb'
      #
      # @example
      #   template '_helpers.erb'
      #
      # @since 0.2.0
      #
      def template(template_path,destination=nil)
        enter_template(template_path) do |path|
          if destination
            super(path,destination)
          else
            ERB.new(File.read(path)).result(binding).chomp
          end
        end
      end

    end
  end
end
