require 'ronin/ui/command_line/commands/gen_extension'

require 'spec_helper'
require 'generated_extension_examples'

require 'tmpdir'
require 'fileutils'

describe UI::CommandLine::Commands::GenExtension do
  before(:all) do
    @name = 'ronin_generated_extension'
    @path = File.join(Dir.tmpdir,@name)

    UI::CommandLine::Commands::GenExtension.start [@path]
  end

  it_should_behave_like "Generated Extension"

  after(:all) do
    FileUtils.rm_r(@path)
  end
end
