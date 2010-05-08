source 'http://rubygems.org'
ronin_ruby = 'git://github.com/ronin-ruby'

group :runtime do
  gem 'open_namespace',	'~> 0.3.0'
  gem 'data_paths',	'~> 0.2.1'
  gem 'thor',		'~> 0.13.0'
  gem 'ronin-support',	'~> 0.1.0', :git => "#{ronin_ruby}/ronin-support.git"
  gem 'ronin',		'~> 0.4.0', :git => "#{ronin_ruby}/ronin.git"
end

group :development do
  gem 'bundler',		'~> 0.9.19'
  gem 'rake',			'~> 0.8.7'
  gem 'jeweler',		'~> 1.4.0', :git => 'git://github.com/technicalpickles/jeweler.git'
end

group :doc do
  case RUBY_ENGINE
  when 'jruby'
    gem 'maruku',	'~> 0.6.0'
  else
    gem 'rdiscount',	'~> 1.6.3'
  end

  gem 'yard',			'~> 0.5.3'
end

gem 'rspec',	'~> 1.3.0', :group => [:development, :test]
