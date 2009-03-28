require 'ronin/static/static'

require 'generators/helpers/generators/file_generator'
require 'generators/helpers/generators/dir_generator'
require 'generators/helpers/generators/templated_generator'

Static.directory File.join(File.dirname(__FILE__),'static')
