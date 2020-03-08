require 'spec_helper'
require 'ronin/gen/generators/repository'

require 'pathname'
require 'tmpdir'

describe Gen::Generators::Repository do
  let(:name) { 'ronin_generated_repo' }
  let(:path) { Pathname.new(Dir.tmpdir).join(name) }
  let(:title) { 'Test Repository' }
  let(:uri) { 'ssh+svn://www.example.com/var/svn/test/' }
  let(:source) { 'http://www.example.com/test/' }
  let(:website) { 'http://www.example.com/blog/' }
  let(:license) { 'GPL-2' }
  let(:description) { 'This is a test repository' }

  before(:all) do
    described_class.generate(path,
      :git         => true,
      :title       => title,
      :uri         => uri,
      :source      => source,
      :website     => website,
      :license     => license,
      :description => description
    )
  end

  it "should create the repository directory" do
    expect(path).to be_directory
  end

  it "should create a data/ directory" do
    expect(path.join('data')).to be_directory
  end

  it "should create a lib/ directory" do
    expect(path.join('lib')).to be_directory
  end

  it "should create a lib/ronin/ directory" do
    expect(path.join('lib','ronin')).to be_directory
  end

  it "should create a scripts/ directory" do
    expect(path.join('scripts')).to be_directory
  end

  it "should create a Rakefile" do
    expect(path.join('Rakefile')).to be_file
  end

  it "should create a 'ronin.yml' file" do
    expect(path.join('ronin.yml')).to be_file
  end

  context "when @git == true" do
    it "should initialize a Git repository" do
      expect(path.join('.git')).to be_directory
    end
  end

  describe "ronin.yml" do
    subject { YAML.load_file(path.join('ronin.yml')) }

    it "should contain a Hash" do
      expect(subject).to be_kind_of(Hash)
    end

    it "should have the title" do
      expect(subject['title']).to eq(title)
    end

    it "should have the repository URI" do
      expect(subject['uri']).to eq(uri)
    end

    it "should have the source URL" do
      expect(subject['source']).to eq(source)
    end

    it "should have the website URL" do
      expect(subject['website']).to eq(website)
    end

    it "should have the license" do
      expect(subject['license']).to eq(license)
    end

    it "should have the description" do
      expect(subject['description'].chomp).to eq(description)
    end
  end

  after(:all) do
    path.rmtree
  end
end
