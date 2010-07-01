require 'spec_helper'
require 'ronin/gen/generators/overlay'

require 'pathname'
require 'tmpdir'

describe Gen::Generators::Overlay do
  before(:all) do
    @name = 'ronin_generated_overlay'
    @path = Pathname.new(Dir.tmpdir).join(@name)
    @title = 'Test Overlay'
    @uri = 'ssh+svn://www.example.com/var/svn/test/'
    @source = 'http://www.example.com/test/'
    @website = 'http://www.example.com/blog/'
    @license = 'GPL-2'
    @description = 'This is a test overlay'

    Gen::Generators::Overlay.generate(
      @path,
      :title => @title,
      :uri => @uri,
      :source => @source,
      :website => @website,
      :license => @license,
      :description => @description
    )
  end

  it "should create the overlay directory" do
    @path.should be_directory
  end

  it "should create a tasks/ directory" do
    @path.join('tasks').should be_directory
  end

  it "should create a data/ directory" do
    @path.join('data').should be_directory
  end

  it "should copy the overlay.xsl file into the data/ directory" do
    @path.join('data','overlay.xsl').should be_file
  end

  it "should create a lib/ directory" do
    @path.join(Ronin::Platform::Overlay::LIB_DIR).should be_directory
  end

  it "should create a lib/ronin/ directory" do
    @path.join(Ronin::Platform::Overlay::LIB_DIR,'ronin').should be_directory
  end

  it "should create a cache/ directory" do
    @path.join(Ronin::Platform::Overlay::CACHE_DIR).should be_directory
  end

  it "should create a exts/ directory" do
    @path.join(Ronin::Platform::Overlay::EXTS_DIR).should be_directory
  end

  it "should create a Rakefile" do
    @path.join('Rakefile').should be_file
  end

  it "should create a XML metadata file" do
    @path.join(Ronin::Platform::Overlay::METADATA_FILE).should be_file
  end

  describe "XML metadata file" do
    before(:all) do
      @doc = Nokogiri::XML(open(@path.join(Ronin::Platform::Overlay::METADATA_FILE)))
      @root = @doc.at('/ronin-overlay')
    end

    it "should have a version" do
      @root['version'].to_i.should == Ronin::Platform::Overlay::FORMAT_VERSION
    end

    it "should have the title" do
      @root.at('title').inner_text.should == @title
    end

    it "should have the repository URI" do
      @root.at('uri').inner_text.should == @uri
    end

    it "should have the source URL" do
      @root.at('source').inner_text.should == @source
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
    @path.rmtree
  end
end
