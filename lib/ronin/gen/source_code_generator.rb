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

require 'ronin/gen/file_generator'

module Ronin
  module Gen
    #
    # A {FileGenerator} class for creating source-code files.
    #
    class SourceCodeGenerator < FileGenerator

      parameter :editor, :type    => String,
                         :default => ENV['EDITOR']

      parameter :edit, :type    => true,
                       :default => true

      #
      # Generates the source code file and spawns a text-editor.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      def generate
        template self.class.template, @path

        if (edit? && editor?)
          # spawn the text editor for the newly generated file
          system(editor,@path)
        end
      end

      protected

      #
      # The template the Source Code Generator will use.
      #
      # @param [String] name
      #   The new template name.
      #
      # @return [String]
      #   The template the Source Code Generator will use.
      #
      # @since 1.1.0
      #
      # @api semipublic
      #
      def self.template(name=nil)
        if name
          @template = name
        else
          @template ||= if superclass < SourceCodeGenerator
                          superclass.template
                        end
        end
      end

    end
  end
end
