require 'ronin/generators/generator'

class TouchGenerator < Generators::Generator

  def generate
    touch('test2.txt')
  end

end
