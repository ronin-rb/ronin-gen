# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'hoe/signing'

Hoe.plugin :yard

Hoe.spec('ronin-gen') do
  self.developer('Postmodern', 'postmodern.mod3@gmail.com')

  self.rspec_options += ['--colour', '--format', 'specdoc']

  self.yard_title = 'Ronin Gen Documentation'
  self.yard_options += ['--protected']
  self.remote_yard_dir = 'docs/ronin-gen'

  self.extra_deps += [
    ['ronin', '>=0.4.0']
  ]

  self.extra_dev_deps += [
    ['rspec', '>=1.2.9']
  ]
end

# vim: syntax=Ruby
