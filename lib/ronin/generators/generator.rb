#
#--
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
#++
#

require 'ronin/static/finders'
require 'ronin/templates/erb'

require 'fileutils'
require 'erb'

module Ronin
  module Generators
    class Generator

      include Static::Finders
      include Templates::Erb

      #
      # Runs the generator with the specified _path_.
      #
      def run(path)
        path = File.expand_path(path)
        @path = path

        generate!

        @path = nil
        return path
      end

      protected

      #
      # Default method which invokes the generator.
      #
      def generate!
      end

      #
      # Returns the absolute form of the specified _path_, with respect to
      # the +path+ instance variable.
      #
      def expand_path(sub_path)
        return @path if (sub_path.nil? || sub_path == @path)
        return File.expand_path(File.join(@path,sub_path))
      end

      #
      # Prints the specified _sub_path_.
      #
      def print_path(sub_path)
        full_path = expand_path(sub_path)

        sub_path = File.join('.',sub_path)
        sub_path << File::SEPARATOR if File.directory?(full_path)

        puts "  #{sub_path}"
      end

      #
      # Opens the file at the specified _sub_path_. If a _block_ is given,
      # it will be passed a newly created File object.
      #
      #   file('metadata.xml') do |file|
      #     ...
      #   end
      #
      def file(sub_path,&block)
        File.open(expand_path(sub_path),'w',&block)

        print_path(sub_path)
        return sub_path
      end

      #
      # Creates a directory at the specified _sub_path_. If a _block_ is
      # given, it will be passed the _sub_path_ after the directory has
      # been created.
      #
      #   directory 'objects'
      #   # => "objects"
      #
      def directory(sub_path,&block)
        FileUtils.mkdir_p(expand_path(sub_path))

        print_path(sub_path)
        block.call(sub_path) if block
        return sub_path
      end

      #
      # Copies the _static_file_ to the specified _sub_path_.
      #
      #   copy 'ronin/platform/generators/extension.rb', 'myext/extension.rb'
      #   # => "myext/extension.rb"
      #
      def copy(static_file,sub_path)
        static_file = find_static_file(static_file)

        FileUtils.cp(static_file,expand_path(sub_path))

        print_path(sub_path)
        return sub_path
      end

      #
      # Renders the ERB template using the specified _static_file_.
      #
      #   render_template 'ronin/platform/generators/Rakefile.erb'
      #   # => "..."
      #
      def render_template(static_file)
        erb(find_static_file(static_file))
      end

      #
      # Renders the ERB template using the specified _static_file_,
      # saving the result to the specified _sub_path_.
      #
      #   render_file 'ronin/platform/generators/Rakefile.erb', 'Rakefile'
      #   # => nil
      #
      def render_file(static_file,sub_path)
        file(sub_path) do |file|
          file.write(render_template(static_file))
        end
      end

    end
  end
end
