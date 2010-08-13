require 'spec_helper'
require 'ronin/gen/gen'
require 'ronin/gen/version'

describe Gen do
  it "should have a version" do
    subject.const_defined?('VERSION').should == true
  end

  it "should load generators from 'ronin/gen/generators'" do
    generator = subject.generator('library')

    generator.should_not be_nil
    generator.name.should == 'Ronin::Gen::Generators::Library'
  end

  it "should raise an UnknownGenerator exception on missing generators" do
    lambda {
      subject.generator('lolbadfail')
    }.should raise_error(Gen::UnknownGenerator)
  end
end
