require 'ronin/generators/platform/overlay'

require 'spec_helper'
require 'generated_overlay_examples'

require 'tmpdir'
require 'fileutils'

describe Generators::Platform::Overlay do

  before(:all) do
    @name = 'ronin_generated_overlay'
    @path = File.join(Dir.tmpdir,@name)
    @title = 'Test Overlay'
    @source = 'ssh+svn://www.example.com/var/svn/test/'
    @source_view = 'http://www.example.com/test/'
    @website = 'http://www.example.com/blog/'
    @license = 'GPL-2'
    @description = 'This is a test overlay'

    generator = Generators::Platform::Overlay.new(
      :title => @title,
      :source => @source,
      :source_view => @source_view,
      :website => @website,
      :license => @license,
      :description => @description
    )
    generator.run(@path)
  end

  it_should_behave_like "Generated Overlay"

  after(:all) do
    FileUtils.rm_r(@path)
  end

end
