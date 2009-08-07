require 'ronin/generators/generator'

require 'spec_helper'
require 'generators/helpers/generators'
require 'generators/classes/file_generator'
require 'generators/classes/touch_generator'
require 'generators/classes/dir_generator'
require 'generators/classes/templated_generator'

require 'tmpdir'
require 'fileutils'

describe Generators::Generator do
  before(:all) do
    @dir = File.join(Dir.tmpdir,'ronin_generators')

    FileUtils.mkdir(@dir)
  end

  it "should generate files" do
    generator = FileGenerator.new
    generator.generate!(@dir)

    File.read(File.join(@dir,'test.txt')).should == "hello"
  end

  it "should touch files" do
    generator = TouchGenerator.new
    generator.generate!(@dir)

    File.file?(File.join(@dir,'test2.txt')).should == true
  end

  it "should generate directories" do
    generator = DirGenerator.new
    generator.generate!(@dir)

    File.directory?(File.join(@dir,'test')).should == true
  end

  it "should generate files using templates" do
    generator = TemplatedGenerator.new
    generator.message = 'hello'
    generator.generate!(@dir)

    File.read(File.join(@dir,'templated.txt')).should == "message: hello\n"
  end

  after(:all) do
    FileUtils.rm_r(@dir)
  end
end
