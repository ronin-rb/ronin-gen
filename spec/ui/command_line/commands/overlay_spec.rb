require 'ronin/ui/command_line/commands/overlay'

require 'spec_helper'
require 'generated_overlay_examples'

require 'tmpdir'
require 'fileutils'

describe UI::CommandLine::Commands::Overlay do
  before(:all) do
    @name = File.join(Dir.tmpdir,'ronin_test_overlay')
    @path = File.join(Dir.tmpdir,@name)

    UI::CommandLine::Commands::Overlay.run(@path)
  end

  it_should_behave_like "Generated Overlay"

  after(:all) do
    FileUtils.rm_r(@path)
  end
end
