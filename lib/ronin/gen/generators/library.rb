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

        # Default license of the library
        DEFAULT_LICENSE = 'GPL-2'

        # Directory to store command classes in
        COMMANDS_DIR = File.join('lib',UI::CLI::Commands.namespace_root)

        # Directory to store generator classes in
        GENERATORS_DIR = File.join('lib',Generators.namespace_root)

        data_dir File.join('ronin','gen','library')

        parameter :name, :type => String

        parameter :version, :type    => String,
                            :default => '0.1.0'

        parameter :author, :type    => String,
                          :default => 'Author'

        parameter :email, :type    => String,
                          :default => 'name@host.com'

        parameter :homepage, :type    => String,
                             :default => 'http://ronin-ruby.github.com/'

        parameter :commands, :type    => Array[String],
                             :default => []

        parameter :generators, :type    => Array[String],
                               :default => []

        parameter :git, :type    => true,
                        :default => true

        #
        # Sets up the library generator.
        #
        def setup
          super

          @name      ||= File.basename(@path)
          @dir_name    = @name.gsub(/^ronin[-_]/,'')
          @module_name = @dir_name.capitalize

          @title = @name.split(/[\s_-]+/).map { |word|
            word.capitalize
          }.join(' ')

          @license = DEFAULT_LICENSE

          @safe_email = @email.gsub(/\s*@\s*/,' at ')

          @bin_script = File.join('bin',"ronin-#{@dir_name}")
        end

        #
        # Generates top-level files.
        #
        def generate
          run "git init" if git?

          template 'Gemfile.erb', 'Gemfile'
          cp 'Rakefile'

          template 'name.gemspec.erb', "#{@name}.gemspec"
          template 'gemspec.yml.erb', 'gemspec.yml'

          cp '.gitignore' if git?
          cp '.rspec'
          cp '.document'
          template '.yardopts.erb', '.yardopts'

          cp 'COPYING.txt'

          template 'ChangeLog.md.erb', 'ChangeLog.md'
          template 'README.md.erb', 'README.md'

          mkdir 'bin'

          template File.join('bin','ronin-name.erb'), @bin_script
          chmod 0755, @bin_script

          mkdir_p File.join('lib','ronin',@dir_name)

          template File.join('lib','ronin','name.rb.erb'),
                   File.join('lib','ronin',"#{@dir_name}.rb")

          template File.join('lib','ronin','name','version.rb.erb'),
                   File.join('lib','ronin',@dir_name,'version.rb')

          mkdir 'data'

          mkdir 'spec'
          template File.join('spec','spec_helper.rb.erb'),
                   File.join('spec','spec_helper.rb')

          mkdir File.join('spec',@dir_name)
          template File.join('spec','name','name_spec.rb.erb'),
                   File.join('spec',@dir_name,"#{@dir_name}_spec.rb")

          generate_commands   unless @commands.empty?
          generate_generators unless @generators.empty?

          if git?
            run 'git add .'
            run 'git commit -m "Initial commit."'
          end
        end

        #
        # Generates any optional commands for the library.
        #
        def generate_commands
          mkdir COMMANDS_DIR

          @commands.each do |name|
            @command_file  = name.downcase.gsub(/[_-]+/,'_')
            @command_class = @command_file.to_const_string

            template File.join('bin','ronin-command.erb'),
                     File.join('bin','ronin-' + @command_file.gsub('_','-'))

            template File.join(COMMANDS_DIR,'command.rb.erb'),
                     File.join(COMMANDS_DIR,"#{@command_file}.rb")
          end
        end

        #
        # Generates any optional generators for the library.
        #
        def generate_generators
          mkdir GENERATORS_DIR

          @generators.each do |name|
            @generator_file  = name.downcase.gsub(/[_-]+/,'_')
            @generator_class = @generator_file.to_const_string

            template File.join(GENERATORS_DIR,'generator.rb.erb'),
                     File.join(GENERATORS_DIR,"#{@generator_file}.rb")
          end
        end

      end
    end
  end
end
