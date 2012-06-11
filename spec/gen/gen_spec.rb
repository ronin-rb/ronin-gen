require 'spec_helper'
require 'ronin/gen/gen'
require 'ronin/gen/version'

describe Gen do
  it "should have a version" do
    subject.const_defined?('VERSION').should == true
  end

  describe "generators" do
    subject { described_class.generators }

    it { should_not be_empty }
  end

  describe "generator" do
    it "should load generators from 'ronin/gen/generators/'" do
      generator = subject.generator('library')

      generator.should == Ronin::Gen::Generators::Library
    end

    it "should raise an UnknownGenerator for unknown generators" do
      lambda {
        subject.generator('foo')
      }.should raise_error(Gen::UnknownGenerator)
    end
  end
end
