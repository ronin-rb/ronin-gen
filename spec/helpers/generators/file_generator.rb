require 'ronin/generators/generator'

class FileGenerator < Generators::Generator

  protected

  def generate!
    file('test.txt') { |test| test.puts("hello") }
  end

end
