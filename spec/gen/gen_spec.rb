require 'spec_helper'
require 'ronin/gen/gen'
require 'ronin/gen/version'

describe Gen do
  it "should have a version" do
    expect(subject.const_defined?('VERSION')).to eq(true)
  end

  describe "generators" do
    subject { described_class.generators }

    it { should_not be_empty }
  end

  describe "generator" do
    it "should load generators from 'ronin/gen/generators/'" do
      generator = subject.generator('library')

      expect(generator).to eq(Ronin::Gen::Generators::Library)
    end

    it "should raise an UnknownGenerator for unknown generators" do
      expect {
        subject.generator('foo')
      }.to raise_error(Gen::UnknownGenerator)
    end
  end
end
