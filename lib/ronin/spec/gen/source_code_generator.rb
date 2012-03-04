require 'rspec'

require 'ronin/gen/source_code_generator'

RSpec.configure do |spec|
  spec.before(:suite) do
    Ronin::Gen::SourceCodeGenerator.edit = false
  end
end
