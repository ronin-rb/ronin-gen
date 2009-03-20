require 'ronin/generators/platform/overlay'

require 'spec_helper'
require 'tmpdir'
require 'fileutils'

describe Generators::Platform::Overlay do

  before(:all) do
    @path = File.join(Dir.tmpdir,'ronin_generated_overlay')
    @title = 'Test Overlay'
    @source = 'ssh+svn://www.example.com/var/svn/test/'
    @source_view = 'http://www.example.com/test/'
    @website = 'http://www.example.com/blog/'
    @license = 'GPL-2'
    @description = 'This is a test overlay'

    generator = Generators::Platform::Overlay.new(
      :title => @title,
      :source => @source,
      :source_view => @source_view,
      :website => @website,
      :license => @license,
      :description => @description
    )
    generator.run(@path)
  end

  it "should create the overlay directory" do
    File.directory?(@path).should == true
  end

  it "should create a lib directory" do
    lib_dir = File.join(@path,Platform::Overlay::LIB_DIR)

    File.directory?(lib_dir).should == true
  end

  it "should create a objects directory" do
    objects_dir = File.join(@path,Platform::Overlay::OBJECTS_DIR)

    File.directory?(objects_dir).should == true
  end

  it "should create a Rakefile" do
    rakefile = File.join(@path,'Rakefile')

    File.file?(rakefile).should == true
  end

  it "should create a XML metadata file" do
    metadata_file = File.join(@path,Platform::Overlay::METADATA_FILE)

    File.file?(metadata_file).should == true
  end

  after(:all) do
    FileUtils.rm_r(@path)
  end

end
