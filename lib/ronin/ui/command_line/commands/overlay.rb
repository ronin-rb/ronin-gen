#
#--
# Ronin Gen - A Ruby library for Ronin that provides various Generators for
# Ronin.
#
# Copyright (c) 2009 Postmodern (postmodern.mod3 at gmail.com)
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
require 'ronin/platform/generators/overlay'

module Ronin
  module UI
    module CommandLine
      module Commands
        class Overlay < Command

          include Nokogiri

          def defaults
            @metadata = Platform::Generators::Overlay.new
          end

          def define_options(opts)
            opts.usage = '[options] PATH'

            opts.options do
              opts.on('-t','--title NAME','Name of the Overlay') do |title|
                @metadata.title = title
              end

              opts.on('-S','--source URL','The URL where the source of the Overlay will be hosted') do |url|
                @metadata.source = url
              end

              opts.on('-V','--source-view URL','The URL for viewing the contents of the Overlay') do |url|
                @metadata.source_view = url
              end

              opts.on('-U','--website URL','The URL of the website of the Overlay') do |url|
                @metadata.website = url
              end

              opts.on('-L','--license LICENSE','The license of the contents of the Overlay') do |license|
                @metadata.license = license
              end

              opts.on('-m','--maintainer "NAME <EMAIL>"','Name of a maintainer of the Overlay') do |text|
                name = text.scan(/^[^<]+[^<\s]/).first
                email = text.scan(/<([^<>]+)>\s*$/).first

                email = email.first if email

                @metadata.maintainers << {:name => name, :email => email}
              end

              opts.on('-D','--description TEXT','The description for the Overlay') do |text|
                @metadata.description = text
              end

              opts.on('--task TASK','Add the TASK to the Overlay') do |task|
                @metadata.tasks << task.to_s
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

            @metadata.generate(File.expand_path(args.first))
          end

        end
      end
    end
  end
end
