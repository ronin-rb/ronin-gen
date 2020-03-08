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
  describe "setup" do
    subject { BasicGenerator.new }

    before(:all) do
      subject.setup
    end

    it "should set default values before invoking any tasks" do
      expect(subject.var).to eq('test')
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

      expect(File.read(File.join(@dir,'test.txt'))).to eq("hello")
    end

    it "should touch files" do
      TouchGenerator.generate

      expect(File.file?(File.join(@dir,'test2.txt'))).to eq(true)
    end

    it "should generate directories" do
      DirGenerator.generate

      expect(File.directory?(File.join(@dir,'test'))).to eq(true)
    end

    it "should generate files using templates" do
      path = File.join(@dir,'templated.txt')

      TemplatedGenerator.generate(:message => 'hello')

      expect(File.read(path).chomp).to eq("message: hello")
    end

    after(:all) do
      FileUtils.rm_r(@dir)
      Dir.chdir(@previous_dir)
    end
  end
end
