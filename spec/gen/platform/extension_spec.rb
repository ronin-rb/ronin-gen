require 'ronin/gen/platform/extension'

require 'spec_helper'
require 'generated_extension_examples'

require 'tmpdir'
require 'fileutils'

describe Gen::Platform::Overlay do
  before(:all) do
    @path = File.join(Dir.tmpdir,'ronin_generated_extension.rb')

    Gen::Platform::Extension.generate({},[@path])
  end

  it_should_behave_like "Generated Extension"

  after(:all) do
    FileUtils.rm_r(@path)
  end
end
