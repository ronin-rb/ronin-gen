require 'ronin/generators/generator'

class BasicGenerator < Generators::Generator

  attr_reader :var

  def generate
  end

  protected

  def defaults
    @var = 'test'
  end

end
