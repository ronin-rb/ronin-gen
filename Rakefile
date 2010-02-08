# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'hoe/signing'
require './lib/ronin/gen/version.rb'

Hoe.plugin :yard

Hoe.spec('ronin-gen') do
  self.version = Ronin::Gen::VERSION
  self.developer('Postmodern', 'postmodern.mod3@gmail.com')

  self.rspec_options += ['--colour', '--format', 'specdoc']

  self.yard_title = 'Ronin Gen Documentation'
  self.yard_options += ['--markup', 'markdown', '--protected']
  self.remote_yard_dir = 'docs/ronin-gen'

  self.extra_deps += [
    ['thor', '>=0.13.0'],
    ['ronin', '>=0.4.0']
  ]

  self.extra_dev_deps += [
    ['rspec', '>=1.3.0'],
    ['yard', '>=0.5.3']
  ]
end

# vim: syntax=Ruby
