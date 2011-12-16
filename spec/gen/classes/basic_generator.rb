require 'ronin/gen/generator'

class BasicGenerator < Gen::Generator

  attr_reader :var

  def setup
    @var = 'test'
  end

  def generate
  end

end
