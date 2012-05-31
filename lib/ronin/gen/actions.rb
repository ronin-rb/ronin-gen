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

require 'ronin/templates/erb'
require 'ronin/ui/output'

require 'fileutils'

module Ronin
  module Gen
    #
    # Action methods for the {Generator} class.
    #
    # @since 1.2.0
    #
    # @api semipublic
    #
    module Actions
      protected
      
      include FileUtils
      include Templates::Erb


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
      def status(command,*arguments)
        unless UI::Output.silent?
          arguments = arguments.join(' ')

          if $stdout.tty?
            command = BOLD + GREEN + command + CLEAR
          end

          puts "\t#{command}\t#{arguments}"
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
      def run(command,*arguments)
        status command, *arguments

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
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#chmod-instance_method
      #
      def chmod(mode,paths)
        status 'chmod', mode.to_s(8), *paths

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
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#chmod_R-instance_method
      #
      def chmod_R(mode,paths)
        status 'chmod -R', mode.to_s(8)

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
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#chown-instance_method
      #
      def chown(user,group,paths)
        status 'chown', "#{user}:#{group}", *paths

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
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#chown_R-instance_method
      #
      def chown_R(user,group,paths)
        status 'chown -R', "#{user}:#{group}", *paths

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
        status 'cp', destination

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
        status 'cp -r', destination

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
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#install-instance_method
      #
      def install(src,dest,options={})
        options = {:mode => options[:mode]} # only pass in :mode

        status 'install', src, dest

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
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#ln-instance_method
      #
      def ln(src,dest)
        status 'ln', src, dest

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
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#ln_s-instance_method
      #
      def ln_s(src,dest)
        status 'ln -s', src, dest

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
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#ln_sf-instance_method
      #
      def ln_sf(src,dest)
        status 'ln -sf', src, dest

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
        status 'mkdir', dir

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
        status 'mkdir -p', dir

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
      # @since 1.1.0
      #
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#mv-instance_method
      #
      def mv(src,dest)
        status 'mv', src, dest

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
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#rm-instance_method
      #
      def rm(paths,options={})
        options = {:force => options[:force]} # only pass in :force

        status 'rm', *paths

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
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#rm_r-instance_method
      #
      def rm_r(paths,options={})
        options = {:force => options[:force]} # only pass in :force

        status 'rm -r', *paths

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
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#rm_rf-instance_method
      #
      def rm_rf(paths)
        status 'rm -rf', *paths

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
      # @see http://rubydoc.info/stdlib/fileutils/FileUtils#rmdir-instance_method
      #
      def rmdir(dirs)
        status 'rmdir', *dirs

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
        status 'touch', path

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
          status 'erb', destination

          File.open(destination,'w') do |file|
            file.write(erb_file(template_path))
          end
        else
          erb_file(template_path).chomp
        end
      end
    end
  end
end
