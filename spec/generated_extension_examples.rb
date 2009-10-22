require 'ronin/platform/extension'

require 'spec_helper'

shared_examples_for "Generated Extension" do
  it "should create the extension file" do
    File.file?(@path).should == true
  end
end
