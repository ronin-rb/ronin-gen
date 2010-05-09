require 'spec_helper'
require 'ronin/gen/generators/extension'

require 'pathname'
require 'tmpdir'

describe Gen::Generators::Extension do
  before(:all) do
    @path = Pathname.new(Dir.tmpdir).join('ronin_generated_extension.rb')

    Gen::Generators::Extension.generate({},[@path])
  end

  it "should create the extension file" do
    @path.should be_file
  end

  after(:all) do
    @path.rmtree
  end
end
