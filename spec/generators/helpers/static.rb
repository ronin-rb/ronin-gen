require 'ronin/config'

module Ronin
  module Config
    register_static_dir File.join(File.dirname(__FILE__),'static')
  end
end
