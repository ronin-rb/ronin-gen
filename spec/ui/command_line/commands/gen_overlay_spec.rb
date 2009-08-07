require 'ronin/ui/command_line/commands/gen_overlay'

require 'spec_helper'
require 'generated_overlay_examples'

require 'tmpdir'
require 'fileutils'

describe UI::CommandLine::Commands::GenOverlay do

  before(:all) do
    @name = 'ronin_generated_overlay'
    @path = File.join(Dir.tmpdir,@name)
    @title = 'Test Overlay'
    @source = 'ssh+svn://www.example.com/var/svn/test/'
    @source_view = 'http://www.example.com/test/'
    @website = 'http://www.example.com/blog/'
    @license = 'GPL-2'
    @description = 'This is a test overlay'

    UI::CommandLine::Commands::GenOverlay.start [
      @path,
      '--title', @title,
      '--source', @source,
      '--source-view', @source_view,
      '--website', @website,
      '--license', @license,
      '--description', @description
    ]
  end

  it_should_behave_like "Generated Overlay"

  after(:all) do
    FileUtils.rm_r(@path)
  end

end
