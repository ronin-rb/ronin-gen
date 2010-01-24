require 'ronin/gen/dir_generator'

class DirGenerator < Gen::Generator

  def generate
    mkdir 'test'
  end

end
