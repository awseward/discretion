require 'overcommit'
require 'yaml'

module Overcommit::Hook::PreCommit
  class ReallyEatYourDogfood < Base
    def description
      "Checking for unused plugins"
    end

    def run
      config = get_config_hash
      installed = get_installed_plugins

      difference = get_difference installed, config

      if difference.empty?
        :pass
      else
        messages = [
          'The following is missing from your .overcommit.yml',
          difference.to_yaml,
        ]

        [:warn, messages.join("\n")]
      end
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
      paths = Dir['.git-hooks/**/*.rb']

      paths.reduce({}) do |seed, curr|
        type = get_hook_type curr
        name = filename_to_classname curr

        hooks = seed[type] || {}
        seed.merge({
          type => hooks.merge(plugin_hash(name))
        })
      end
    end

    def intersect(h1, h2)
      h2_keys = h2.keys
      h1.select{|key,_| h2_keys.include? key}
    end

    def except(h1, h2)
      h2_keys = h2.keys
      h1.reject{|key,_| h2_keys.include? key}
    end

    def get_difference_r(expected, actual, recurse)
      expected.reduce({}) do |seed, curr|
        if actual.has_key? curr.first
          if recurse
            difference = get_difference_r curr.last, actual[curr.first], false
            if difference.empty?
              seed
            else
              seed.merge({curr.first => difference})
            end
          else
            seed
          end
        else
          seed.merge({curr.first => curr.last})
        end
      end
    end

    def get_difference(expected, actual)
      get_difference_r expected, actual, true
    end
  end
end
