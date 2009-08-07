require 'ronin/generators/generator'

class TemplatedGenerator < Generators::Generator

  TEMPLATE_FILE = File.join('generators','templated.txt.erb')

  no_tasks do
    attr_accessor :message
  end

  def generate
    template TEMPLATE_FILE, 'templated.txt'
  end

end
