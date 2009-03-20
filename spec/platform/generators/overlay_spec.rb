require 'ronin/platform/generators/overlay'

require 'spec_helper'
require 'tmpdir'
require 'fileutils'

describe Platform::Generators::Overlay do

  before(:all) do
    @overlay_path = File.join(Dir.tmpdir,'ronin_generated_overlay')

    generator = Platform::Generators::Overlay.new
    generators.run(@overlay_path)
  end

  it "should create the overlay directory" do
    File.directory?(@overlay_path).should == true
  end

  after(:all) do
    FileUtils.rm_r(@overlay_path)
  end

end
