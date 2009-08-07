require 'ronin/generators/generator'

class FileGenerator < Generators::Generator

  def generate
    create_file('test.txt') do
      "hello"
    end
  end

end
