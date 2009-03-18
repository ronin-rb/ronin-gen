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

module Ronin
  module Generators
    class Generator

      include Static::Finders

      # Root directory to generate within
      attr_accessor :root

      #
      # Default method which invokes the generator.
      #
      def generate
      end

      protected

      #
      # Creates the file at the specified _path_ within the root directory,
      # passing the newly created File object to the given _block_.
      #
      def create_file(path,&block)
        path = File.join(@root,path)

        File.open(path,'w',&block)
      end

      #
      # Creates a directory at the specified _path_ within the root
      # directory.
      #
      def create_dir(path)
        path = File.join(@root,path)

        FileUtils.mkdir_p(path)
      end

      #
      # Creates a file at the specified _path_ within the root directory,
      # using the ERB template with the specified _name_.
      def template_file(path,name)
        template_path = find_static_file(name)
        erb = ERB.new(File.read(template_path))

        create_file(path) do |file|
          file.write(erb.result(binding))
        end
      end

    end
  end
end
