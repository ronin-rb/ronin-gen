require 'ronin/ui/command_line/commands/extension'

require 'spec_helper'
require 'tmpdir'
require 'fileutils'

describe UI::CommandLine::Commands::Extension do
  before(:all) do
    @ext_dir = File.join(Dir.tmpdir,'ronin_test_ext')
  end

  it "should be able to generate an extension directory" do
    UI::CommandLine::Commands::Extension.run(@ext_dir)

    File.directory?(@ext_dir).should == true
  end

  after(:all) do
    FileUtils.rm_r(@ext_dir)
  end
end
