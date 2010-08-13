require 'spec_helper'
require 'ronin/gen/generators/overlay'

require 'pathname'
require 'tmpdir'

describe Gen::Generators::Library do
  context "defaults" do
    let(:path) { Pathname.new(Dir.tmpdir).join('ronin-name') }

    before(:all) do
      Gen::Generators::Library.generate(path)
    end

    it "should create a bin/ directory" do
      path.join('bin').should be_directory
    end

    it "should create a lib/ directory" do
      path.join('lib').should be_directory
    end

    it "should create a lib/ronin directory" do
      path.join('lib','ronin').should be_directory
    end

    it "should create a lib/ronin/name.rb directory" do
      path.join('lib','ronin','name.rb').should be_file
    end

    it "should create a lib/ronin/name directory" do
      path.join('lib','ronin','name').should be_directory
    end

    it "should create a lib/ronin/name/version.rb file" do
      path.join('lib','ronin','name','version.rb').should be_file
    end

    it "should create a data/ directory" do
      path.join('data').should be_directory
    end

    it "should create a spec/ directory" do
      path.join('spec').should be_directory
    end

    it "should create a spec/spec_helper.rb file" do
      path.join('spec','spec_helper.rb').should be_file
    end

    it "should create a spec/name directory" do
      path.join('spec','name').should be_directory
    end

    it "should create a spec/name/name_spec.rb file" do
      path.join('spec','name','name_spec.rb').should be_file
    end

    it "should create a COPYING.txt file" do
      path.join('COPYING.txt').should be_file
    end

    it "should create a README.md file" do
      path.join('README.md').should be_file
    end

    it "should create a ChangeLog.md file" do
      path.join('ChangeLog.md').should be_file
    end

    it "should create a Rakefile" do
      path.join('Rakefile').should be_file
    end

    it "should create a .specopts file" do
      path.join('.specopts').should be_file
    end

    it "should create a .yardopts file" do
      path.join('.yardopts').should be_file
    end

    after(:all) do
      path.rmtree
    end
  end

  context "custom path and name" do
    let(:name) { 'ronin-name' }
    let(:path) { Pathname.new(Dir.tmpdir).join('ronin-library') }

    before(:all) do
      Gen::Generators::Library.generate(path, {:name => name})
    end

    it "should create a lib/ronin/name.rb file" do
      path.join('lib','ronin','name.rb').should be_file
    end

    it "should create a lib/ronin/name/ directory" do
      path.join('lib','ronin','name').should be_directory
    end

    it "should create a lib/ronin/name/version.rb file" do
      path.join('lib','ronin','name','version.rb').should be_file
    end

    it "should create a bin/ronin-name file" do
      path.join('bin','ronin-name').should be_file
    end

    it "should create a spec/name directory" do
      path.join('spec','name').should be_directory
    end

    it "should create a spec/name/name_spec.rb file" do
      path.join('spec','name','name_spec.rb').should be_file
    end

    after(:all) do
      path.rmtree
    end
  end
end
