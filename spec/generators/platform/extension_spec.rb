require 'ronin/generators/platform/extension'

require 'spec_helper'
require 'tmpdir'
require 'fileutils'

describe Generators::Platform::Overlay do

  before(:all) do
    @name = 'ronin_generated_extension'
    @path = File.join(Dir.tmpdir,@name)
    @lib_dir = File.join(@path,Platform::Extension::LIB_DIR)

    generator = Generators::Platform::Extension.new
    generator.run(@path)
  end

  it "should create the extension directory" do
    File.directory?(@path).should == true
  end

  it "should create a lib/ directory" do
    File.directory?(@lib_dir).should == true
  end

  it "should create an empty load file in the lib/ directory" do
    File.file?(File.join(@lib_dir,@name + '.rb')).should == true
  end

  it "should create an empty directory within the lib/ directory" do
    File.directory?(File.join(@lib_dir,@name)).should == true
  end

  after(:all) do
    FileUtils.rm_r(@path)
  end

end
