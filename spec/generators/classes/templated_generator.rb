require 'ronin/generators/generator'

class TemplatedGenerator < Generators::Generator

  TEMPLATE_FILE = File.join('generators','templated.txt.erb')

  def initialize(message)
    @message = message
  end

  protected

  def generate!
    render_file TEMPLATE_FILE, 'templated.txt'
  end

end
