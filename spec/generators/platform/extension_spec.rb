require 'ronin/generators/platform/extension'

require 'spec_helper'
require 'generated_extension_examples'

require 'tmpdir'
require 'fileutils'

describe Generators::Platform::Overlay do

  before(:all) do
    @name = 'ronin_generated_extension'
    @path = File.join(Dir.tmpdir,@name)

    Generators::Platform::Extension.generator(@path)
  end

  it_should_behave_like "Generated Extension"

  after(:all) do
    FileUtils.rm_r(@path)
  end

end
