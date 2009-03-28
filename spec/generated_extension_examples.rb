require 'ronin/platform/extension'

require 'spec_helper'

shared_examples_for "Generated Extension" do

  before(:all) do
    @lib_dir = File.join(@path,Ronin::Platform::Extension::LIB_DIR)
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

end
