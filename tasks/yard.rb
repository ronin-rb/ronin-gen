require 'ronin/yard/handlers'

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']
  t.options = [
    '--protected',
    '--files', 'History.txt',
    '--title', 'Ronin Generators',
    '--quiet'
  ]
end

task :docs => :yard
