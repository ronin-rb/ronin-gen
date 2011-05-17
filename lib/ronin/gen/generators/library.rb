#
# Copyright (c) 2009-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/ui/cli/commands'
require 'ronin/gen/dir_generator'
require 'ronin/gen/config'
require 'ronin/gen/version'
require 'ronin/support/version'
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

        # Directory to store command classes in
        COMMANDS_DIR = File.join('lib',UI::CLI::Commands.namespace_root)

        # Directory to store generator classes in
        GENERATORS_DIR = File.join('lib',Generators.namespace_root)

        desc 'Generates a new Ronin library'
        class_option :name, :type => :string
        class_option :version, :type => :string, :default => DEFAULT_VERSION
        class_option :author, :type => :string, :default => DEFAULT_AUTHOR
        class_option :email, :type => :string, :default => DEFAULT_EMAIL
        class_option :homepage, :type => :string,
                                :default => DEFAULT_HOMEPAGE

        class_option :commands, :type => :array,
                                :default => [],
                                :banner => 'NAME [...]'

        class_option :generators, :type => :array,
                                  :default => [],
                                  :banner => 'NAME [...]'

        class_option :no_git, :type => :boolean

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
          unless options[:no_git]
            inside { run "git init" }
          end

          erb File.join('ronin','gen','library','Gemfile.erb'), 'Gemfile'
          cp File.join('ronin','gen','library','Rakefile'), 'Rakefile'

          erb File.join('ronin','gen','library','library.gemspec.erb'),
              "#{@name}.gemspec"
          erb File.join('ronin','gen','library','gemspec.yml.erb'),
              'gemspec.yml'

          unless options[:no_git]
            cp File.join('ronin','gen','library','.gitignore'), '.gitignore'
          end

          cp File.join('ronin','gen','library','.rspec'), '.rspec'
          cp File.join('ronin','gen','library','.document'), '.document'
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
          erb File.join('ronin','gen','library','bin','ronin-name.erb'),
              File.join('bin',"ronin-#{@dir_name}")
        end

        #
        # Generates the contents of the `lib` directory.
        #
        def lib
          mkdir File.join('lib','ronin',@dir_name)

          erb File.join('ronin','gen','library','lib','ronin','name.rb.erb'),
              File.join('lib','ronin',"#{@dir_name}.rb")

          erb File.join('ronin','gen','library','lib','ronin','name','version.rb.erb'),
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
          erb File.join('ronin','gen','library','spec','name','name_spec.rb.erb'),
              File.join('spec',@dir_name,"#{@dir_name}_spec.rb")
        end

        #
        # Generates any optional commands for the library.
        #
        def commands
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

        #
        # Finalizes the generated library.
        #
        def finalize
          unless options[:no_git]
            inside do
              run('git add .')
              run('git commit -m "Initial commit."')
            end
          end
        end

      end
    end
  end
end
