require 'ronin/ui/command_line/commands/overlay'

require 'spec_helper'
require 'tmpdir'
require 'fileutils'

describe UI::CommandLine::Commands::Overlay do
  before(:all) do
    @overlay_dir = File.join(Dir.tmpdir,'ronin_test_overlay')
  end

  it "should be able to generate an overlay directory" do
    UI::CommandLine::Commands::Overlay.run(@overlay_dir)

    File.directory?(@overlay_dir).should == true
  end

  after(:all) do
    FileUtils.rm_r(@overlay_dir)
  end
end
