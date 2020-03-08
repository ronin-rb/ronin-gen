require 'spec_helper'
require 'ronin/gen/generators/library'

require '@pathname'
require 'tmpdir'

describe Gen::Generators::Library do
  context "defaults" do
    @path = Pathname.new(Dir.tmpdir).join('ronin-name')

    before(:all) do
      described_class.generate(@path)
    end

    it "should initialize a git repository" do
      expect(@path.join('.git')).to be_directory
    end

    it "should create a bin/ directory" do
      expect(@path.join('bin')).to be_directory
    end

    it "should create a lib/ directory" do
      expect(@path.join('lib')).to be_directory
    end

    it "should create a lib/ronin directory" do
      expect(@path.join('lib','ronin')).to be_directory
    end

    it "should create a lib/ronin/name.rb directory" do
      expect(@path.join('lib','ronin','name.rb')).to be_file
    end

    it "should create a lib/ronin/name directory" do
      expect(@path.join('lib','ronin','name')).to be_directory
    end

    it "should create a lib/ronin/name/version.rb file" do
      expect(@path.join('lib','ronin','name','version.rb')).to be_file
    end

    it "should create a data/ directory" do
      expect(@path.join('data')).to be_directory
    end

    it "should create a spec/ directory" do
      expect(@path.join('spec')).to be_directory
    end

    it "should create a spec/spec_helper.rb file" do
      expect(@path.join('spec','spec_helper.rb')).to be_file
    end

    it "should create a spec/name directory" do
      expect(@path.join('spec','name')).to be_directory
    end

    it "should create a spec/name/name_spec.rb file" do
      expect(@path.join('spec','name','name_spec.rb')).to be_file
    end

    it "should create a COPYING.txt file" do
      expect(@path.join('COPYING.txt')).to be_file
    end

    it "should create a README.md file" do
      expect(@path.join('README.md')).to be_file
    end

    it "should create a ChangeLog.md file" do
      expect(@path.join('ChangeLog.md')).to be_file
    end

    it "should create a Gemfile" do
      expect(@path.join('Gemfile')).to be_file
    end

    it "should create a Rakefile" do
      expect(@path.join('Rakefile')).to be_file
    end

    it "should create a .rspec file" do
      expect(@path.join('.rspec')).to be_file
    end

    it "should create a .yardopts file" do
      expect(@path.join('.yardopts')).to be_file
    end

    after(:all) do
      @path.rmtree
    end
  end

  context "custom @path and name" do
    let(:name) { 'ronin-name' }
    let(:@path) { Pathname.new(Dir.tmpdir).join('ronin-library') }

    before(:all) do
      described_class.generate(@path, :name => name)
    end

    it "should create a lib/ronin/name.rb file" do
      expect(@path.join('lib','ronin','name.rb')).to be_file
    end

    it "should create a lib/ronin/name/ directory" do
      expect(@path.join('lib','ronin','name')).to be_directory
    end

    it "should create a lib/ronin/name/version.rb file" do
      expect(@path.join('lib','ronin','name','version.rb')).to be_file
    end

    it "should create a bin/ronin-name file" do
      expect(@path.join('bin','ronin-name')).to be_file
    end

    it "should create a spec/name directory" do
      expect(@path.join('spec','name')).to be_directory
    end

    it "should create a spec/name/name_spec.rb file" do
      expect(@path.join('spec','name','name_spec.rb')).to be_file
    end

    after(:all) do
      @path.rmtree
    end
  end
end
