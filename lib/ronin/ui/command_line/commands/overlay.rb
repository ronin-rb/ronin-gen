#
#--
# Ronin Gen - A Ruby library for Ronin that provides various generators.
#
# Copyright (c) 2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/ui/command_line/command'
require 'ronin/generators/platform/overlay'

module Ronin
  module UI
    module CommandLine
      module Commands
        class Overlay < Command

          def defaults
            @generator = Generators::Platform::Overlay.new
          end

          def define_options(opts)
            opts.usage = '[options] PATH'

            opts.options do
              opts.on('-t','--title NAME','Name of the Overlay') do |title|
                @generator.title = title
              end

              opts.on('-S','--source URL','The URL where the source of the Overlay will be hosted') do |url|
                @generator.source = url
              end

              opts.on('-V','--source-view URL','The URL for viewing the contents of the Overlay') do |url|
                @generator.source_view = url
              end

              opts.on('-U','--website URL','The URL of the website of the Overlay') do |url|
                @generator.website = url
              end

              opts.on('-L','--license LICENSE','The license of the contents of the Overlay') do |license|
                @generator.license = license
              end

              opts.on('-m','--maintainer "NAME <EMAIL>"','Name of a maintainer of the Overlay') do |text|
                name = text.scan(/^[^<]+[^<\s]/).first
                email = text.scan(/<([^<>]+)>\s*$/).first

                email = email.first if email

                @generator.maintainers << {:name => name, :email => email}
              end

              opts.on('-D','--description TEXT','The description for the Overlay') do |text|
                @generator.description = text
              end

              opts.on('--task TASK','Add the TASK to the Overlay') do |task|
                @generator.tasks << task.to_s
              end
            end

            opts.arguments(
              'PATH' => 'The PATH of the Overlay to be created'
            )

            opts.summary('Create an empty Overlay at the specified PATH')
          end

          def arguments(*args)
            unless args.length == 1
              fail('only one Overlay path maybe specified')
            end

            @generator.run(File.expand_path(args.first))
          end

        end
      end
    end
  end
end
