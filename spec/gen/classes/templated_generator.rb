require 'ronin/gen/generator'

class TemplatedGenerator < Gen::Generator

  TEMPLATE_FILE = File.join('generators','templated.txt.erb')

  class_option :message, :type => :string

  def generate
    erb TEMPLATE_FILE, 'templated.txt'
  end

end
