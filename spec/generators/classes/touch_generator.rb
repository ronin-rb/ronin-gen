require 'ronin/generators/generator'

class TouchGenerator < Generators::Generator

  protected

  def generate!
    touch('test2.txt')
  end

end
