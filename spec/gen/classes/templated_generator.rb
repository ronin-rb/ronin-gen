require 'ronin/gen/generator'

class TemplatedGenerator < Gen::Generator

  TEMPLATE_FILE = File.join('generators','templated.txt.erb')

  parameter :message, type: String

  def generate
    template TEMPLATE_FILE, 'templated.txt'
  end

end
