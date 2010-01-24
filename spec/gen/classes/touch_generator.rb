require 'ronin/gen/generator'

class TouchGenerator < Gen::Generator

  def generate
    touch('test2.txt')
  end

end
