require 'ronin/gen/version'

require 'spec_helper'

describe Gen do
  it "should have a version" do
    Gen.const_defined?('VERSION').should == true
  end
end
