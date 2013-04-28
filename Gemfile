source 'https://rubygems.org'

DM_URI     = 'http://github.com/datamapper'
DM_VERSION = '~> 1.2'
RONIN_URI  = 'http://github.com/ronin-ruby'

gemspec

gem 'jruby-openssl',	'~> 0.7', :platforms => :jruby

# Ronin dependencies:
# gem 'ronin-support',	'~> 0.5', :git => "#{RONIN_URI}/ronin-support.git"
# gem 'ronin',		      '~> 1.5', :git => "#{RONIN_URI}/ronin.git"

group :development do
  gem 'rake',		        '~> 10.0'
  gem 'rubygems-tasks', '~> 0.1'
  gem 'rspec',		      '~> 2.4'

  platforms :mri, :rbx do
    gem 'redcarpet',      '~> 2.1'
    gem 'md2man',         '~> 1.2', :git => 'http://github.com/postmodern/md2man.git', :branch => 'rake_task'
  end
end

#
# To enable additional DataMapper adapters for development work or for
# testing purposes, simple set the ADAPTER or ADAPTERS environment
# variable:
#
#     export ADAPTER="postgres"
#     bundle install
#
#     ./bin/ronin --database postgres://ronin@localhost/ronin
#
require 'set'

DM_ADAPTERS = Set['postgres', 'mysql', 'oracle', 'sqlserver']

adapters = (ENV['ADAPTER'] || ENV['ADAPTERS']).to_s
adapters = Set.new(adapters.to_s.tr(',',' ').split)

(DM_ADAPTERS & adapters).each do |adapter|
  gem "dm-#{adapter}-adapter", DM_VERSION #, :git => "#{DM_URI}/dm-#{adapter}-adapter.git"
end
