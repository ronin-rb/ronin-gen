require 'ronin/generators/generator'

class DirGenerator < Generators::Generator

  protected

  def generate!
    directory 'test'
  end

end
