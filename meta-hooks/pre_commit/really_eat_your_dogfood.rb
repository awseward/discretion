require 'overcommit'
require 'yaml'

module Overcommit::Hook::PreCommit
  class ReallyEatYourDogfood < Base
    def description
      "Checking for unused plugins"
    end

    def run
      [:warn, get_installed_plugins.to_yaml]
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

    def plugin_hash(plugin)
      {plugin => {"enabled" => true}}
    end

    def get_installed_plugins
      paths = Dir['*hooks/**/*.rb']

      paths.reduce({}) do |seed, curr|
        type = get_hook_type curr
        name = filename_to_classname curr

        hooks = seed[type] || {}
        seed.merge({
          type => hooks.merge(plugin_hash(name))
        })
      end
    end
  end
end
