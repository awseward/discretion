require 'overcommit'
require 'yaml'

module Overcommit::Hook::PreCommit
  class ReallyEatYourDogfood < Base
    def description
      "Checking for unused plugins"
    end

    def run
      [:warn, 'TODO']
    end

    private
    def get_config_hash
      YAML.load_file '.overcommit.yml'
    end

    def filename_to_classname(filename)
      no_ext = File.basename filename, File.extname(filename)

      no_ext.split("_").collect(&:capitalize).join
    end

    def get_hook_type(path)
      filename_to_classname File.dirname(path)
    end

    def base_enabled_hash(plugin)
      {plugin => {"enabled" => true}}
    end

    def get_installed_plugins
      paths = Dir['*hooks/**/*.rb']

      paths.reduce({}) do |seed, curr|
        type = get_hook_type curr
        name = filename_to_classname curr

        if seed.has_key?(type)
          hooks = seed[type]
          new_hash = {type => hooks.merge(base_enabled_hash(name))}
          seed.merge new_hash
        else
          new_hash = {type => base_enabled_hash(name)}
          seed.merge new_hash
        end
      end
    end
  end
end
