require 'rubygems'
require 'rake'
require './lib/ronin/gen/version.rb'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'ronin-gen'
    gem.version = Ronin::Gen::VERSION
    gem.licenses = ['GPL-2']
    gem.summary = %Q{A Ruby library for Ronin that provides various generators.}
    gem.description = %Q{Ronin Gen is a Ruby library for Ronin that provides various generators.}
    gem.email = 'postmodern.mod3@gmail.com'
    gem.homepage = 'http://github.com/ronin-ruby/ronin-gen'
    gem.authors = ['Postmodern']
    gem.add_dependency 'open_namespace', '~> 0.2.0'
    gem.add_dependency 'data_paths', '~> 0.2.1'
    gem.add_dependency 'thor', '~> 0.13.0'
    gem.add_dependency 'ronin', '~> 0.4.0'
    gem.add_development_dependency 'rspec', '~> 1.3.0'
    gem.add_development_dependency 'yard', '~> 0.5.3'
    gem.has_rdoc = 'yard'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs += ['lib', 'spec']
  spec.spec_files = FileList['spec/**/*_spec.rb']
  spec.spec_opts = ['--options', '.specopts']
end

task :spec => :check_dependencies
task :default => :spec

begin
  require 'yard'

  YARD::Rake::YardocTask.new
rescue LoadError
  task :yard do
    abort "YARD is not available. In order to run yard, you must: gem install yard"
  end
end
