require 'ronin/gen/gen'
require 'ronin/gen/version'

require 'spec_helper'

describe Gen do
  it "should have a version" do
    Gen.const_defined?('VERSION').should == true
  end

  it "should load generators from 'ronin/gen/generators'" do
    generator = Gen.generator('library')

    generator.should_not be_nil
    generator.name.should == 'Ronin::Gen::Generators::Library'
  end

  it "should raise an UnknownGenerator exception on missing generators" do
    lambda {
      Gen.generator('lolbadfail')
    }.should raise_error(Gen::UnknownGenerator)
  end
end
