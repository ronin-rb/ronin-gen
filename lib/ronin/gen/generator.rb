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
require 'ronin/support/inflector'
require 'ronin/templates/erb'
require 'ronin/ui/output'

require 'parameters'
require 'data_paths/finders'
require 'fileutils'

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
      include FileUtils
      include Templates::Erb

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
      # The name of the generator.
      #
      # @return [String]
      #   The generator name.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      def self.generator_name
        @generator_name ||= Support::Inflector.underscore(
          self.name.sub('Ronin::Gen::Generators::','').gsub('::',':')
        )
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
      # Runs a command.
      #
      # @param [String] command
      #   The command or program to run.
      #
      # @param [Array<String>] arguments
      #   Additional arguments to run the program with.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      def run(command,*arguments)
        print_action command, *arguments

        system(command,*arguments)
      end

      #
      # Changes the permissions of a files or directories.
      #
      # @param [String, Integer] mode
      #   The new permissions for the files or directories.
      #
      # @param [Array<String>] paths
      #   The path to the files or directories.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#chmod-instance_method
      #
      def chmod(mode,paths)
        print_action 'chmod', mode.to_s(8), *paths

        super(mode,paths)
      end

      #
      # Changes the permissions of files/directories, recursively.
      #
      # @param [String, Integer] mode
      #   The new permissions for the files or directories.
      #
      # @param [Array<String>] paths
      #   The path to the files or directories.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#chmod_R-instance_method
      #
      def chmod_R(mode,paths)
        print_action 'chmod -R', mode.to_s(8)

        super(mode,paths)
      end

      #
      # Changes ownership of files or directories.
      #
      # @param [String, nil] user
      #   The new owner of the files or directories.
      #
      # @param [String, nil] group
      #   The new group for the files or directories.
      #
      # @param [Array<String>] paths
      #   The path to the files or directories.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#chown-instance_method
      #
      def chown(user,group,paths)
        print_action 'chown', "#{user}:#{group}", *paths

        super(user,group,paths)
      end

      #
      # Changes ownership of files/directories, recursively.
      #
      # @param [String, nil] user
      #   The new owner of the files or directories.
      #
      # @param [String, nil] group
      #   The new group for the files or directories.
      #
      # @param [Array<String>] paths
      #   The path to the files or directories.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#chown_R-instance_method
      #
      def chown_R(user,group,paths)
        print_action 'chown -R', "#{user}:#{group}", *paths

        super(user,group,paths)
      end

      #
      # Copies a data file.
      #
      # @param [String] file
      #   The relative path to the data file.
      #
      # @param [String] destination
      #   The destination to copy the data file to.
      #
      # @since 0.2.0
      #
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#cp-instance_method
      #
      def cp(file,destination=file)
        print_action 'cp', destination

        super(data_file(file),destination)
      end

      #
      # Copies the contents of all data directories.
      #
      # @param [String] directory
      #   The data directories to copy from.
      #
      # @param [String, nil] destination
      #   The optional destination directory to copy the files to.
      #
      # @since 1.0.0
      #
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#cp_r-instance_method
      #
      def cp_r(directory,destination=directory)
        print_action 'cp -r', destination

        data_dirs(directory) do |dir|
          super(dir,destination)
        end
      end

      #
      # Installs a file.
      #
      # @param [String] src
      #   The file to install.
      #
      # @param [String] dest
      #   The destination path for the file.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [String, Integer] :mode
      #   The permissions of the installed file.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#install-instance_method
      #
      def install(src,dest,options={})
        options = {:mode => options[:mode]} # only pass in :mode

        print_action 'install', src, dest

        super(data_file(src),dest,options)
      end

      #
      # Creates a hard link.
      #
      # @param [String] src
      #   The path file/directory for the hard link.
      # 
      # @param [String] dest
      #   The destination file/directory of the hard link.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#ln-instance_method
      #
      def ln(src,dest)
        print_action 'ln', src, dest

        super(src,dest)
      end

      #
      # Creates a symbolic link.
      #
      # @param [String] src
      #   The path file/directory for the symbolic link.
      # 
      # @param [String] dest
      #   The destination file/directory of the symbolic link.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#ln_s-instance_method
      #
      def ln_s(src,dest)
        print_action 'ln -s', src, dest

        super(src,dest)
      end

      #
      # Forcibly creates a symbolic link.
      #
      # @param [String] src
      #   The path file/directory for the symbolic link.
      # 
      # @param [String] dest
      #   The destination file/directory of the symbolic link.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#ln_sf-instance_method
      #
      def ln_sf(src,dest)
        print_action 'ln -sf', src, dest

        super(src,dest)
      end

      #
      # Creates an empty directory.
      #
      # @param [String] dir
      #   The relative path of the directory to create.
      #
      # @example
      #   mkdir 'sub/dir'
      #
      # @since 0.2.0
      #
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#mkdir-instance_method
      #
      def mkdir(dir)
        print_action 'mkdir', dir

        super(dir)
      end

      #
      # Creates an empty directory.
      #
      # @param [String] dir
      #   The relative path of the directory to create.
      #
      # @example
      #   mkdir 'sub/dir'
      #
      # @since 0.2.0
      #
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#mkdir_p-instance_method
      #
      def mkdir_p(dir)
        print_action 'mkdir -p', dir

        super(dir)
      end

      #
      # Moves a file or directory.
      #
      # @param [String] src
      #   The path to the file or directory.
      #
      # @param [String] dest
      #   The new path to move the file or directory to.
      #
      # @api semipublic
      #
      # @since 1.1.0
      #
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#mv-instance_method
      #
      def mv(src,dest)
        print_action 'mv', src, dest

        super(src,dest)
      end

      #
      # Removes one or more files.
      #
      # @param [Array<String>] paths
      #   The paths of the files and directories to remove.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Boolean] :force
      #   Specifies whether to forcible remove the files.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#rm-instance_method
      #
      def rm(paths,options={})
        options = {:force => options[:force]} # only pass in :force

        print_action 'rm', *paths

        super(paths,options)
      end

      #
      # Recursively removes files and directories.
      #
      # @param [Array<String>] paths
      #   The paths of the files and directories to remove.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Boolean] :force
      #   Specifies whether to forcible remove the files.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#rm_r-instance_method
      #
      def rm_r(paths,options={})
        options = {:force => options[:force]} # only pass in :force

        print_action 'rm -r', *paths

        super(paths,options)
      end

      #
      # Forcibly removes files and directories, recursively.
      #
      # @param [Array<String>] paths
      #   The paths of the files and directories to remove.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#rm_rf-instance_method
      #
      def rm_rf(paths)
        print_action 'rm -rf', *paths

        super(paths)
      end

      #
      # Removes one or more directories.
      #
      # @param [Array<String>] dirs
      #   The paths of the directories.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#rmdir-instance_method
      #
      def rmdir(dirs)
        print_action 'rmdir', *dirs

        super(dirs)
      end

      #
      # Touches a file.
      #
      # @param [String] path
      #   The relative path to the file to touch.
      #
      # @example
      #   touch 'TODO.txt'
      #
      # @since 0.2.0
      #
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#touch-instance_method
      #
      def touch(path)
        print_action 'touch', path

        return super(path)
      end

      #
      # Opens a file for writing.
      #
      # @param [String] path
      #   The path of the file to write to.
      #
      # @yield [file]
      #   The given block will be passed the newly opened file.
      #
      # @yieldparam [File]
      #   The new file file, opened for writing.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      def write(path,&block)
        File.open(path,'wb',&block)
      end

      #
      # Renders the ERB template and saves the result.
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
      #   template 'Rakefile.erb', 'Rakefile'
      #
      # @example
      #   template '_helpers.erb'
      #
      # @since 0.2.0
      #
      def template(template_path,destination=nil)
        if destination
          print_action 'erb', destination

          File.open(destination,'w') do |file|
            file.write(erb_file(template_path))
          end
        else
          erb_file(template_path).chomp
        end
      end

      private

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

      # ANSI Bold code
      BOLD = "\e[1m"

      # ANSI Green code
      GREEN = "\e[32m"

      # ANSI Clear code
      CLEAR = "\e[0m"

      #
      # Prints a file action.
      #
      # @param [String] command
      #   The command/options that represents the file action.
      #
      # @param [Array<String>] arguments
      #   Additional arguments related to the file action.
      #
      # @since 1.1.0
      #
      # @api private
      #
      def print_action(command,*arguments)
        unless UI::Output.silent?
          arguments = arguments.join(' ')

          if $stdout.tty?
            command = BOLD + GREEN + command + CLEAR
          end

          puts "\t#{command}\t#{arguments}"
        end
      end

    end
  end
end
