#
# Ronin Gen - A Ruby library for Ronin that provides various generators.
#
# Copyright (c) 2009-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/gen/file_generator'

module Ronin
  module Gen
    #
    # A {FileGenerator} class for creating Ruby files.
    #
    class RubyGenerator < FileGenerator

      class_option :editor, :default => ENV['EDITOR']
      class_option :no_edit, :type => :boolean

      #
      # Generates the Ruby file and spawns a text-editor.
      #
      def self.generate(options={},arguments=[],&block)
        generator = super(options,arguments) do |gen|
          gen.path += '.rb' unless gen.path =~ /\.rb$/
        end

        if (!generator.options.no_edit? && generator.options.editor)
          system(generator.options.editor,generator.path)
        end
      end

    end
  end
end
