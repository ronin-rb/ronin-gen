require 'ronin/gen/generator'

class BasicGenerator < Gen::Generator

  attr_reader :var

  def generate
  end

  protected

  def setup
    @var = 'test'
  end

end
