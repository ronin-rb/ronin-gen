require 'ronin/gen/generators/overlay'

require 'spec_helper'

require 'tmpdir'
require 'fileutils'

describe Gen::Generators::Overlay do
  before(:all) do
    @name = 'ronin_generated_overlay'
    @path = File.join(Dir.tmpdir,@name)
    @title = 'Test Overlay'
    @source = 'ssh+svn://www.example.com/var/svn/test/'
    @source_view = 'http://www.example.com/test/'
    @website = 'http://www.example.com/blog/'
    @license = 'GPL-2'
    @description = 'This is a test overlay'

    Gen::Generators::Overlay.generate(
      @path,
      :title => @title,
      :source => @source,
      :source_view => @source_view,
      :website => @website,
      :license => @license,
      :description => @description
    )
  end

  it "should create the overlay directory" do
    File.directory?(@path).should == true
  end

  it "should create a tasks/ directory" do
    tasks_dir = File.join(@path,'tasks')

    File.directory?(tasks_dir).should == true
  end

  it "should create a static/ directory" do
    static_dir = File.join(@path,'static')

    File.directory?(static_dir).should == true
  end

  it "should copy the overlay.xsl file into the static/ directory" do
    overlay_xsl = File.join(@path,'static','overlay.xsl')

    File.file?(overlay_xsl).should == true
  end

  it "should create a lib/ directory" do
    lib_dir = File.join(@path,Ronin::Platform::Overlay::LIB_DIR)

    File.directory?(lib_dir).should == true
  end

  it "should create a cache/ directory" do
    cache_dir = File.join(@path,Ronin::Platform::Overlay::CACHE_DIR)

    File.directory?(cache_dir).should == true
  end

  it "should create a exts/ directory" do
    exts_dir = File.join(@path,Ronin::Platform::Overlay::EXTS_DIR)

    File.directory?(exts_dir).should == true
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
      @root = @doc.at('/ronin-overlay')
    end

    it "should have a version" do
      @root['version'].to_i.should == Ronin::Platform::Overlay::VERSION
    end

    it "should have the title" do
      @root.at('title').inner_text.should == @title
    end

    it "should have the source URL" do
      @root.at('source').inner_text.should == @source
    end

    it "should have the source-view URL" do
      @root.at('source-view').inner_text.should == @source_view
    end

    it "should have the website URL" do
      @root.at('website').inner_text.should == @website
    end

    it "should have the license" do
      @root.at('license').inner_text.should == @license
    end

    it "should have the description" do
      @root.at('description').inner_text.should == @description
    end
  end

  after(:all) do
    FileUtils.rm_r(@path)
  end
end