require 'ronin/gen/generators/extension'

require 'spec_helper'

require 'tmpdir'
require 'fileutils'

describe Gen::Generators::Extension do
  before(:all) do
    @path = File.join(Dir.tmpdir,'ronin_generated_extension.rb')

    Gen::Generators::Extension.generate({},[@path])
  end

  it "should create the extension file" do
    File.file?(@path).should == true
  end

  after(:all) do
    FileUtils.rm_r(@path)
  end
end
