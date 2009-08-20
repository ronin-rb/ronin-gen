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

require 'ronin/static/finders'

require 'extlib'
require 'erb'
require 'thor'

module Ronin
  module Generators
    class Generator < Thor::Group

      include Thor::Actions
      include Static::Finders

      def self.inherited(super_class)
        class_name = super_class.name.split('::').last.snake_case
        super_class.namespace("ronin #{class_name}")
      end

      #
      # Defines the default source root of the generator as the current
      # working directory.
      #
      def self.source_root
        Dir.pwd
      end

      #
      # Invokes the generator with the given _options_ and the given
      # _arguments_.
      #
      #   gen.generate
      #
      def self.generate(options={},arguments=[])
        generator = self.new(arguments, options)
        generator.invoke()
      end

      desc "default generator task"

      #
      # Default generator method.
      #
      def generate
      end

      protected

      #
      # Touches the file at the specified _destination_.
      #
      #   touch 'TODO.txt'
      #
      def touch(destination)
        create_file(destination)
      end

      #
      # Creates an empty directory at the specified _destination_.
      #
      #   directory 'sub/dir'
      #
      def mkdir(destination)
        empty_directory(destination)
      end

      #
      # Copies the _static_file_ to the specified _destination_.
      #
      #   copy_file 'ronin/platform/generators/extension.rb',
      #             'myext/extension.rb'
      #
      def copy_file(static_file,destination)
        super(find_static_file(static_file),destination)
      end

      #
      # Renders the ERB template using the specified _static_file_ and
      # saves the result at the given _destination_. If _destination_
      # is not given, the result will simply be returned.
      #
      #   template 'ronin/platform/generators/Rakefile.erb', 'Rakefile.erb'
      #
      def template(static_file,destination=nil)
        path = find_static_file(static_file)

        if destination
          return super(path,destination)
        else
          return ERB.new(File.read(path)).result(binding).chomp
        end
      end

    end
  end
end
