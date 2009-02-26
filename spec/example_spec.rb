require 'ronin/example/version'

require 'spec_helper'

describe Example do
  it "should have a version" do
    Example.const_defined?('VERSION').should == true
  end
end
