require 'ronin/generators/generator'

class DirGenerator < Generators::Generator

  def generate
    mkdir 'test'
  end

end
