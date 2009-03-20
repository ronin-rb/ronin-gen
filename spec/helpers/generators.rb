require 'ronin/static/static'

require 'helpers/generators/file_generator'
require 'helpers/generators/dir_generator'
require 'helpers/generators/templated_generator'

Static.directory File.join(File.dirname(__FILE__),'static')
