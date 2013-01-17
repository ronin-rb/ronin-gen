require 'spec_helper'
require 'ronin/gen/generators/script'

require 'pathname'
require 'tmpdir'

describe Gen::Generators::Script do
  let(:name) { 'myscript.rb' }
  let(:path) { Pathname.new(Dir.tmpdir).join(name) }

  before(:all) do
    described_class.generate(path)
  end

  it "should create the file" do
    path.should be_file
  end

  it "should mark the file executable" do
    path.should be_executable
  end

  describe "the created file" do
    subject { path.read }

    it "should start with '#!/usr/bin/env ruby'" do
      subject.lines.first.chomp.should == "#!/usr/bin/env ruby"
    end

    it "should include 'if $0 == __FILE__'" do
      subject.should include("if $0 == __FILE__")
    end

    it "should require 'ronin/support'" do
      subject.should include("require 'ronin/support'")
    end

    context "when ronin is enabled" do
      before(:all) { described_class.generate(path, :ronin => true) }

      it "should require 'ronin'" do
        subject.should include("require 'ronin'")
      end
    end
  end

  after(:all) do
    path.delete
  end
end
