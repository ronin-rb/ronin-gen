require 'ronin/generators/generator'
require 'ronin/generators/config'

require 'fileutils'
require 'erb'

module Ronin
  module Platform
    module Generators
      class ExtensionGenerator < Generator

        def generate(path)
          extension_path = File.join(path,Platform::Extension::EXTENSION_FILE)
          lib_dir = File.join(path,Platform::Extension::LIB_DIR)
          template_path = File.join(Config::STATIC_DIR,'extension.rb')

          FileUtils.mkdir_p(path)
          FileUtils.mkdir_p(lib_dir)
          FileUtils.touch(File.join(lib_dir,File.basename(path) + '.rb'))
          FileUtils.mkdir_p(File.join(lib_dir,File.basename(path)))
          FileUtils.cp(template_path,extension_path)
        end

      end
    end
  end
end
