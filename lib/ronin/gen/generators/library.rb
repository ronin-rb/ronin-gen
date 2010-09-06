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

require 'ronin/ui/command_line/commands'
require 'ronin/gen/generators'
require 'ronin/gen/config'
require 'ronin/gen/dir_generator'
require 'ronin/version'

module Ronin
  module Gen
    module Generators
      #
      # Generates a completely new Ronin library.
      #
      class Library < DirGenerator

        # Default version of the library
        DEFAULT_VERSION = '0.1.0'

        # Default license of the library
        DEFAULT_LICENSE = 'GPL-2'

        # Default author of the library
        DEFAULT_AUTHOR = 'Author'

        # Default email of the library
        DEFAULT_EMAIL = 'name@host.com'

        # Default homepage for the library
        DEFAULT_HOMEPAGE = 'http://ronin-ruby.github.com/'

        # Default RSpec version to use
        RSPEC_VERSION = '1.3.0'

        # Default YARD version to use
        YARD_VERSION = '0.5.3'

        # Directory to store command classes in
        COMMANDS_DIR = File.join('lib',UI::CommandLine::Commands.namespace_root)

        # Directory to store generator classes in
        GENERATORS_DIR = File.join('lib',Generators.namespace_root)

        desc 'Generates a new Ronin library'
        class_option :name, :type => :string
        class_option :version, :type => :string, :default => DEFAULT_VERSION
        class_option :author, :type => :string, :default => DEFAULT_AUTHOR
        class_option :email, :type => :string, :default => DEFAULT_EMAIL
        class_option :homepage, :type => :string,
                                :default => DEFAULT_HOMEPAGE
        class_option :commands, :type => :array, :default => []
        class_option :generators, :type => :array, :default => []

        def setup
          @name = (options[:name] || File.basename(self.path))
          @dir_name = @name.gsub(/^ronin[-_]/,'')
          @module_name = @dir_name.capitalize

          @title = @name.split(/[\s_-]+/).map { |word|
            word.capitalize
          }.join(' ')

          @license = DEFAULT_LICENSE

          @author = options[:author]
          @email = options[:email]
          @safe_email = @email.gsub(/\s*@\s*/,' at ')
          @homepage = options[:homepage]
        end

        #
        # Generates top-level files.
        #
        def generate
          cp File.join('ronin','gen','library','Gemfile'), 'Gemfile'
          erb File.join('ronin','gen','library','Rakefile.erb'), 'Rakefile'

          cp File.join('ronin','gen','library','.rspec'), '.rspec'
          erb File.join('ronin','gen','library','.yardopts.erb'),
              '.yardopts'

          cp File.join('ronin','gen','library','COPYING.txt'), 'COPYING.txt'

          erb File.join('ronin','gen','library','ChangeLog.md.erb'),
             'ChangeLog.md'

          erb File.join('ronin','gen','library','README.md.erb'),
             'README.md'

          mkdir 'data'
        end

        #
        # Generates the contents of the `bin` directory.
        #
        def bin
          mkdir 'bin'
          erb File.join('ronin','gen','library','bin','ronin-example.erb'),
              File.join('bin',"ronin-#{@dir_name}")
        end

        #
        # Generates the contents of the `lib` directory.
        #
        def lib
          mkdir File.join('lib','ronin',@dir_name)

          erb File.join('ronin','gen','library','lib','ronin','example.rb.erb'),
              File.join('lib','ronin',"#{@dir_name}.rb")

          erb File.join('ronin','gen','library','lib','ronin','example','version.rb.erb'),
              File.join('lib','ronin',@dir_name,'version.rb')
        end

        #
        # Generates the test suite.
        #
        def test_suite
          mkdir 'spec'
          erb File.join('ronin','gen','library','spec','spec_helper.rb.erb'),
              File.join('spec','spec_helper.rb')

          mkdir File.join('spec',@dir_name)
          erb File.join('ronin','gen','library','spec','example','example_spec.rb.erb'),
              File.join('spec',@dir_name,"#{@dir_name}_spec.rb")
        end

        #
        # Generates any optional commands for the library.
        #
        def command_line
          unless options[:commands].empty?
            mkdir COMMANDS_DIR

            options[:commands].each do |name|
              @command_file = name.downcase.gsub(/[_-]+/,'_')
              @command_class = @command_file.to_const_string

              erb File.join('ronin','gen','library','bin','ronin-command.erb'),
                  File.join('bin','ronin-' + @command_file.gsub('_','-'))

              erb File.join('ronin','gen','library',COMMANDS_DIR,'command.rb.erb'),
                  File.join(COMMANDS_DIR,"#{@command_file}.rb")
            end
          end
        end

        #
        # Generates any optional generators for the library.
        #
        def gen
          unless options[:generators].empty?
            mkdir GENERATORS_DIR

            options[:generators].each do |name|
              @generator_file = name.downcase.gsub(/[_-]+/,'_')
              @generator_class = @generator_file.to_const_string

              erb File.join('ronin','gen','library',GENERATORS_DIR,'generator.rb.erb'),
                  File.join(GENERATORS_DIR,"#{@generator_file}.rb")
            end
          end
        end

      end
    end
  end
end
