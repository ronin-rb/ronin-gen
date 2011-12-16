require 'ronin/gen/generator'

class FileGenerator < Gen::Generator

  def generate
    write('test.txt') do |file|
      file << "hello"
    end
  end

end
