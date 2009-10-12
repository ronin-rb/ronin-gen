require 'ronin/platform/overlay'

require 'spec_helper'
require 'nokogiri'

shared_examples_for "Generated Overlay" do

  it "should create the overlay directory" do
    File.directory?(@path).should == true
  end

  it "should create a static directory" do
    static_dir = File.join(@path,'static')

    File.directory?(static_dir).should == true
  end

  it "should create a lib directory" do
    lib_dir = File.join(@path,Ronin::Platform::Overlay::LIB_DIR)

    File.directory?(lib_dir).should == true
  end

  it "should create a cache directory" do
    cache_dir = File.join(@path,Ronin::Platform::Overlay::CACHE_DIR)

    File.directory?(cache_dir).should == true
  end

  it "should create a Rakefile" do
    rakefile = File.join(@path,'Rakefile')

    File.file?(rakefile).should == true
  end

  it "should create a XML metadata file" do
    metadata_file = File.join(@path,Ronin::Platform::Overlay::METADATA_FILE)

    File.file?(metadata_file).should == true
  end

  describe "XML metadata file" do
    before(:all) do
      @doc = Nokogiri::XML(open(File.join(@path,Ronin::Platform::Overlay::METADATA_FILE)))
    end

    it "should have the title" do
      @doc.at('/ronin-overlay/title').inner_text.should == @title
    end

    it "should have the source URL" do
      @doc.at('/ronin-overlay/source').inner_text.should == @source
    end

    it "should have the source-view URL" do
      @doc.at('/ronin-overlay/source-view').inner_text.should == @source_view
    end

    it "should have the website URL" do
      @doc.at('/ronin-overlay/website').inner_text.should == @website
    end

    it "should have the license" do
      @doc.at('/ronin-overlay/license').inner_text.should == @license
    end

    it "should have the description" do
      @doc.at('/ronin-overlay/description').inner_text.should == @description
    end
  end

end
