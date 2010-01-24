require 'ronin/gen/generator'

class FileGenerator < Gen::Generator

  def generate
    create_file('test.txt') do
      "hello"
    end
  end

end
