require 'rubygems'
gem 'rspec', '>=1.1.12'
require 'spec'

require 'ronin/generators/version'

include Ronin

OVERLAY_ROOT = File.expand_path(File.join(File.dirname(__FILE__),'..'))
