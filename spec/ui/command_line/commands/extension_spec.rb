require 'ronin/ui/command_line/commands/extension'

require 'spec_helper'
require 'generated_extension_examples'

require 'tmpdir'
require 'fileutils'

describe UI::CommandLine::Commands::Extension do
  before(:all) do
    @name = 'ronin_generated_extension'
    @path = File.join(Dir.tmpdir,@name)

    UI::CommandLine::Commands::Extension.run(@path)
  end

  it_should_behave_like "Generated Extension"

  after(:all) do
    FileUtils.rm_r(@path)
  end
end
