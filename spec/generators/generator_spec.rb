require 'ronin/generators/generator'

require 'spec_helper'
require 'generators/helpers/generators'

require 'tmpdir'
require 'fileutils'

describe Generators::Generator do
  before(:all) do
    @dir = File.join(Dir.tmpdir,'ronin_generators')

    FileUtils.mkdir(@dir)
  end

  it "should generate files" do
    generator = FileGenerator.new
    generator.run(@dir)

    File.read(File.join(@dir,'test.txt')).should == "hello\n"
  end

  it "should generate directories" do
    generator = DirGenerator.new
    generator.run(@dir)

    File.directory?(File.join(@dir,'test')).should == true
  end

  it "should generate files using templates" do
    generator = TemplatedGenerator.new('hello')
    generator.run(@dir)

    File.read(File.join(@dir,'templated.txt')).should == "message: hello\n"
  end

  after(:all) do
    FileUtils.rm_r(@dir)
  end
end
