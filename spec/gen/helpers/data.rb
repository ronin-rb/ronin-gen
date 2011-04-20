require 'data_paths'

module Helpers
  module Gen
    include DataPaths

    register_data_path File.join(File.dirname(__FILE__),'data')
  end
end
