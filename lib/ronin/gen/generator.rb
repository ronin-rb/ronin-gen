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

require 'ronin/templates/template'

require 'data_paths/finders'
require 'extlib'
require 'erb'
require 'thor'
require 'thor/group'
require 'thor/actions'

module Ronin
  module Gen
    #
    # The {Generator} class leverages `Thor::Group` and `Thor::Actions`
    # to create a generic generator class. The generator class can
    # define `class_options` that can be used to parse command-line
    # arguments or set directly in Ruby.
    #
    # # Extending
    #
    # To create a new type of generator one can extend {Generator},
    # {FileGenerator} or {DirGenerator} classes. The new generator can
    # define it's own `class_options`, which are made available to other
    # classes that extend our generator. The functionality of the generator
    # is defined via instance methods, which are called sequentially when
    # the generator is invoked.
    #
    #     require 'ronin/gen/file_generator'
    #
    #     module Ronin
    #       module Gen
    #         module Generators
    #           class MyGenerator < FileGenerator
    #
    #             desc 'My generator'
    #
    #             # generator options
    #             class_option :stuff, :type => :boolean
    #             class_option :syntax, :type => :string
    #             class_option :includes, :type => :array
    #
    #             #
    #             # Performs the generation.
    #             #
    #             def generate
    #               erb 'some_template.erb', self.path
    #             end
    #
    #           end
    #         end
    #       end
    #     end
    #
    # # Invoking
    #
    # To invoke the generator from ruby, one can call the {generate}
    # class method with the options and arguments to run the generator with:
    #
    #     MyGenerator.generate(
    #       {:stuff => true, :syntax => 'bla', :includes => ['other']}
    #       ['path/to/file'],
    #     )
    #
    # To make your generator accessible to the `ronin-gen` command, simply
    # place your generator file within the `ronin/gen/generators` directory
    # of any Ronin library. If your generator class is named
    # `MyGenerator`, than it's ruby file must be named `my_generator.rb`.
    #
    # To run the generator using the `ronin-gen` command, simply specify
    # it's underscored name:
    #
    #     ronin-gen my_generator path/to/file --stuff --syntax bla --includes other
    #
    class Generator < Thor::Group

      include Thor::Actions
      include Templates::Template
      include DataPaths::Finders

      def self.inherited(super_class)
        class_name = super_class.name.sub('Ronin::Gen::Generators::','')
        gen_name = class_name.split('::').join(':').snake_case

        super_class.namespace(gen_name)
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
      # @since 0.3.0
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
      # @yield [generator]
      #   The given block will be passed the new generator.
      #
      # @yieldparam [Generator] generator
      #   The newly created generator object.
      #
      # @return [Generator]
      #   The generate object.
      #
      # @example
      #   gen.generate
      #
      # @since 0.2.0
      #
      def self.generate(options={},arguments=[],&block)
        generator = self.new(arguments,options,&block)
        generator.invoke_all()

        return generator
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
      # @since 0.3.0
      #
      def initialize(arguments=[],options={},config={})
        super(arguments,options,config)

        setup()

        yield self if block_given?
      end

      #
      # Default method to initialize any instance variables before any of
      # the tasks are invoked.
      #
      # @since 0.3.0
      #
      def setup
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
      # Copies a data file.
      #
      # @param [String] data_file
      #   The relative path to the data file.
      #
      # @param [String] destination
      #   The destination to copy the data file to.
      #
      # @example
      #   copy_file 'ronin/platform/generators/extension.rb',
      #             'myext/extension.rb'
      #
      # @since 0.2.0
      #
      def cp(data_file,destination)
        copy_file(find_data_file(data_file),destination)
      end

      #
      # Copies the contents of all data directories.
      #
      # @param [String] data_dir
      #   The data directories to copy from.
      #
      # @param [String, nil] destination
      #   The optional destination directory to copy the files to.
      #
      # @param [Hash] config
      #   The optional configuration information.
      #
      # @option config [Boolean] :recursive (false)
      #   Recursively copies the contents.
      #
      # @since 0.3.0
      #
      def cp_r(data_dir,destination=nil,config={})
        each_data_dir(data_dir) do |dir|
          directory(dir,destination || data_dir,config)
        end
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
      #   If destination is `nil`, the result of the rendered template
      #   will be returned.
      #
      # @example
      #   erb 'ronin/platform/generators/Rakefile.erb', 'Rakefile.erb'
      #
      # @example
      #   erb '_helpers.erb'
      #
      # @since 0.2.0
      #
      def erb(template_path,destination=nil)
        if destination
          enter_template(template_path) do |path|
            template(path,destination)
          end
        else
          read_template(template_path) do |template|
            ERB.new(template).result(binding).chomp
          end
        end
      end

    end
  end
end
