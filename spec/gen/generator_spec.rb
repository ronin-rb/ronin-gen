require 'spec_helper'
require 'ronin/gen/generator'

require 'gen/helpers/data'
require 'gen/classes/basic_generator'
require 'gen/classes/file_generator'
require 'gen/classes/touch_generator'
require 'gen/classes/dir_generator'
require 'gen/classes/templated_generator'
require 'tmpdir'
require 'fileutils'

describe Gen::Generator do
  it "should include Thor::Actions" do
    Gen::Generator.should include(Thor::Actions)
  end

  describe "setup" do
    subject { BasicGenerator.new }

    before(:all) do
      subject.invoke_all
    end

    it "should set default values before invoking any tasks" do
      subject.var.should == 'test'
    end
  end

  describe "actions" do
    before(:all) do
      @previous_dir = Dir.pwd
      @dir = File.join(Dir.tmpdir,'ronin_generators')

      FileUtils.mkdir(@dir)
      Dir.chdir(@dir)
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
end
