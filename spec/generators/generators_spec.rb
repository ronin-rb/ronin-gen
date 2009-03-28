require 'ronin/generators/version'

require 'spec_helper'

describe Generators do
  it "should have a version" do
    Generators.const_defined?('VERSION').should == true
  end
end
