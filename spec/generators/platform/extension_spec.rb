require 'ronin/generators/platform/extension'

require 'spec_helper'
require 'generated_extension_examples'

require 'tmpdir'
require 'fileutils'

describe Generators::Platform::Overlay do
  before(:all) do
    @path = File.join(Dir.tmpdir,'ronin_generated_extension.rb')

    Generators::Platform::Extension.generate({},[@path])
  end

  it_should_behave_like "Generated Extension"

  after(:all) do
    FileUtils.rm_r(@path)
  end
end
