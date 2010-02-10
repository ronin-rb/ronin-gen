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

require 'ronin/gen/config'
require 'ronin/gen/dir_generator'
require 'ronin/version'

module Ronin
  module Gen
    module Generators
      class Library < DirGenerator

        DEFAULT_VERSION = '0.1.0'

        DEFAULT_AUTHOR = 'Author'

        DEFAULT_EMAIL = 'name@host.com'

        RSPEC_VERSION = '1.3.0'

        YARD_VERSION = '0.5.3'

        COMMANDS_DIR = File.join('ronin','ui','command_line','commands')

        GENERATORS_DIR = File.join('ronin','gen','generators')

        class_option :name, :type => :string
        class_option :author, :type => :string, :default => DEFAULT_AUTHOR
        class_option :email, :type => :string, :default => DEFAULT_EMAIL
        class_option :version, :type => :string, :default => DEFAULT_VERSION
        class_option :commands, :type => :array, :default => []
        class_option :generators, :type => :array, :default => []

        def setup
          @name = (options[:name] || File.basename(self.destination_root))
          @dir_name = @name.gsub(/^ronin[-_]/,'')
          @module_name = @dir_name.capitalize

          @title = @name.split(/[\s_-]+/).map { |word|
            word.capitalize
          }.join(' ')

          @author = options[:author]
          @email = options[:email]
          @safe_email = @email.gsub(/\s*@\s*/,' at ')
        end

        def generate
          copy_file File.join('ronin','gen','library','COPYING.txt'),
            'COPYING.txt'

          mkdir 'static'
        end

        def bin
          mkdir 'bin'
          template File.join('ronin','gen','library','bin','ronin-example.erb'),
            File.join('bin',"ronin-#{@dir_name}")
        end

        def lib
          mkdir File.join('lib','ronin',@dir_name)

          template File.join('ronin','gen','library','lib','ronin','example.rb.erb'),
            File.join('lib','ronin',"#{@dir_name}.rb")
          template File.join('ronin','gen','library','lib','ronin','example','version.rb.erb'),
            File.join('lib','ronin',@dir_name,'version.rb')
        end

        def history
          template File.join('ronin','gen','library','History.md.erb'),
            'History.md'
        end

        def manifest
          template File.join('ronin','gen','library','Manifest.txt.erb'),
            'Manifest.txt'
        end

        def readme
          template File.join('ronin','gen','library','README.md.erb'),
            'README.md'
        end

        def rakefile
          template File.join('ronin','gen','library','Rakefile.erb'),
            'Rakefile'
        end

        def test_suite
          mkdir 'spec'
          template File.join('ronin','gen','library','spec','spec_helper.rb.erb'),
            File.join('spec','spec_helper.rb')

          mkdir File.join('spec',@dir_name)
          template File.join('ronin','gen','library','spec','example','example_spec.rb.erb'),
            File.join('spec',@dir_name,"#{@dir_name}_spec.rb")
        end

        def command_line
          unless options[:commands].empty?
            mkdir COMMANDS_DIR

            options[:commands].each do |name|
              @command_file = name.downcase.gsub(/[_-]+/,'_')
              @command_class = @command_file.to_const_string

              template File.join('ronin','gen','library','bin','ronin-command.erb'),
                File.join('bin','ronin-' + @command_file.gsub('_','-'))

              template File.join('ronin','gen','library','lib',COMMANDS_DIR,'command.rb.erb'),
                File.join('lib',COMMANDS_DIR,"#{@command_file}.rb")
            end
          end
        end

        def gen
          unless options[:generators].empty?
            mkdir GENERATORS_DIR

            options[:generators].each do |name|
              @generator_file = name.downcase.gsub(/[_-]+/,'_')
              @generator_class = @generator_file.to_const_string

              template File.join('ronin','gen','library','lib',GENERATORS_DIR,'generator.rb.erb'),
                File.join('lib',GENERATORS_DIR,"#{@generator_file}.rb")
            end
          end
        end

      end
    end
  end
end
