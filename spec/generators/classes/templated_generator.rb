require 'ronin/generators/generator'

class TemplatedGenerator < Generators::Generator

  TEMPLATE_FILE = File.join('generators','templated.txt.erb')

  class_option :message, :type => :string

  def generate
    template TEMPLATE_FILE, 'templated.txt'
  end

end
