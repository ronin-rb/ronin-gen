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

require 'thor'

module Ronin
  module Generators
    class Generator < Thor::Group

      include Thor::Actions
      include Static::Finders

      alias path destination_root
      alias path= destination_root=

      no_tasks do
        def generate!(path)
          self.path = File.expand_path(path)

          generate()

          self.path = nil
          return path
        end
      end

      desc "default generator task"

      #
      # Default generator method.
      #
      def generate
      end

      protected

      #
      # Copies the _static_file_ to the specified _destination_.
      #
      #   copy_file 'ronin/platform/generators/extension.rb', 'myext/extension.rb'
      #
      def copy_static_file(static_file,destination)
        copy_file(find_static_file(static_file),destination)
      end

      #
      # Renders the ERB template using the specified _static_file_.
      #
      #   template 'ronin/platform/generators/Rakefile.erb', 'Rakefile.erb'
      #
      def static_template(static_file,destination)
        template(find_static_file(static_file),destination)
      end

    end
  end
end
