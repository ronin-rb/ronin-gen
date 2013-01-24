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

require 'ronin/gen/config'
require 'ronin/gen/actions'

require 'parameters'
require 'data_paths/finders'

module Ronin
  module Gen
    #
    # The {Generator} class is a generate base-class for all file,
    # source-code or directory generators.
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
    #             # generator options
    #             parameter :stuff,    :type => true
    #             parameter :syntax,   :type => String
    #             parameter :includes, :type => Array
    #
    #             #
    #             # Performs the generation.
    #             #
    #             def generate
    #               template 'some_template.erb', path
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
    #       :stuff    => true,
    #       :syntax   => 'bla',
    #       :includes => ['other']
    #       :path     => 'path/to/file',
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
    #     ronin-gen my_generator path/to/file --stuff \
    #                                         --syntax bla \
    #                                         --includes other
    #
    class Generator

      include Parameters
      include DataPaths::Finders
      include Actions

      #
      # Initializes the generator.
      #
      # @param [Hash{Symbol => Object}] options
      #   The options for the generator.
      #
      # @yield [generator]
      #   The given block will be passed the newly created generator.
      #
      # @yieldparam [Generator]
      #   The newly created generator.
      #
      # @api semipublic
      #
      def initialize(options={})
        initialize_params(options)

        if self.class.data_dir
          self.template_dirs << find_data_dir(self.class.data_dir)
        end

        yield self if block_given?
      end

      #
      # Invokes the generator.
      #
      # @param [Array] arguments
      #   Arguments for {#initialize}.
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
      # @api public
      #
      def self.generate(*arguments,&block)
        generator = new(*arguments,&block)

        generator.generate!
        return generator
      end

      #
      # Sets up the generator and calls {#generate}.
      #
      # @see #setup
      # @see #generate
      #
      # @since 1.1.0
      #
      # @api public
      #
      def generate!
        setup
        generate
      end

      #
      # Default method to initialize any instance variables before any of
      # the tasks are invoked.
      #
      # @since 1.0.0
      #
      # @api semipublic
      #
      def setup
      end

      #
      # Default generator method.
      #
      # @since 0.2.0
      #
      # @api semipublic
      #
      def generate
      end

      protected

      #
      # The default data directory of the generator.
      #
      # @param [String] new_dir
      #   The new data directory.
      #
      # @return [String, nil]
      #   The data directory that the generator will search for source files
      #   within.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      def self.data_dir(new_dir=nil)
        if new_dir
          @data_dir = new_dir
        else
          @data_dir ||= if superclass < Generator
                          superclass.data_dir
                        end
        end
      end

      #
      # Joins the path with the Generators {data_dir}.
      #
      # @param [String] path
      #   A relative path.
      #
      # @return [String]
      #   The full `data/` directory path.
      #
      # @since 1.1.0
      #
      # @api private
      #
      def data_path(path)
        if self.class.data_dir
          path = File.join(self.class.data_dir,path)
        end

        return path
      end

      #
      # Searches for a file within the Generators {data_dir}.
      #
      # @param [String] path
      #   The relative path to search for.
      #
      # @return [String]
      #   The path to the file.
      #
      # @raise [StandardError]
      #   The file could not be found in the Generators {data_dir}.
      #
      # @since 1.1.0
      #
      # @api private
      #
      def data_file(path)
        unless (full_path = find_data_file(data_path(path)))
          raise(StandardError,"cannot find generator file: #{path.dump}")
        end

        return full_path
      end

      #
      # Searches for a directory within the Generators {data_dir}.
      #
      # @param [String] path
      #   The relative path to search for.
      #
      # @return [String]
      #   The path to the directory.
      #
      # @raise [StandardError]
      #   The directory could not be found in the Generators {data_dir}.
      #
      # @since 1.1.0
      #
      # @api private
      #
      def data_dir(path)
        unless (full_path = find_data_dir(data_path(path)))
          raise(StandardError,"cannot find generator directory: #{path.dump}")
        end

        return full_path
      end

      #
      # Searches for all matching directories within the Generators {data_dir}.
      #
      # @param [String] path
      #   The relative directory path to search for.
      #
      # @yield [dir]
      #   The given block will be passed each found directory.
      #
      # @yieldparam [String] dir
      #   A directory with the same relative path.
      #
      # @since 1.1.0
      #
      # @api private
      #
      def data_dirs(path,&block)
        each_data_dir(data_path(directory),&block)
      end

    end
  end
end
