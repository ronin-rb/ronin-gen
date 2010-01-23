require 'ronin/generators/generator'

require 'spec_helper'
require 'generators/helpers/static'
require 'generators/classes/basic_generator'
require 'generators/classes/file_generator'
require 'generators/classes/touch_generator'
require 'generators/classes/dir_generator'
require 'generators/classes/templated_generator'

require 'tmpdir'
require 'fileutils'

describe Generators::Generator do
  before(:all) do
    @previous_dir = Dir.pwd
    @dir = File.join(Dir.tmpdir,'ronin_generators')

    FileUtils.mkdir(@dir)
    Dir.chdir(@dir)
  end

  it "should set default values before invoking any tasks" do
    @generator = BasicGenerator.new

    @generator.invoke
    @generator.var.should == 'test'
  end

  it "should generate files" do
    FileGenerator.generate

    File.read(File.join(@dir,'test.txt')).should == "hello"
  end

  it "should touch files" do
    TouchGenerator.generate

    File.file?(File.join(@dir,'test2.txt')).should == true
  end

  it "should generate directories" do
    DirGenerator.generate

    File.directory?(File.join(@dir,'test')).should == true
  end

  it "should generate files using templates" do
    TemplatedGenerator.generate(:message => 'hello')

    File.read(File.join(@dir,'templated.txt')).should == "message: hello\n"
  end

  after(:all) do
    FileUtils.rm_r(@dir)
    Dir.chdir(@previous_dir)
  end
end
