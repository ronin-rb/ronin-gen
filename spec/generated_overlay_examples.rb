require 'ronin/platform/overlay'

require 'spec_helper'

shared_examples_for "Generated Overlay" do

  it "should create the overlay directory" do
    File.directory?(@path).should == true
  end

  it "should create a lib directory" do
    lib_dir = File.join(@path,Ronin::Platform::Overlay::LIB_DIR)

    File.directory?(lib_dir).should == true
  end

  it "should create a objects directory" do
    objects_dir = File.join(@path,Ronin::Platform::Overlay::OBJECTS_DIR)

    File.directory?(objects_dir).should == true
  end

  it "should create a Rakefile" do
    rakefile = File.join(@path,'Rakefile')

    File.file?(rakefile).should == true
  end

  it "should create a XML metadata file" do
    metadata_file = File.join(@path,Ronin::Platform::Overlay::METADATA_FILE)

    File.file?(metadata_file).should == true
  end

end
