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

      diff = key_diff installed, config

      if diff.empty?
        :pass
      else
        messages = [
          'The following is missing from your .overcommit.yml',
          diff.to_yaml,
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

    def key_diff_r(h1, h2, maxDepth, currDepth)
      h1.reduce({}) do |seed, current|
        if !h2.has_key? current.first
          seed.merge({current.first => current.last})
        else
          if (currDepth == maxDepth)
            seed
          else
            diff = key_diff_r current.last, h2[current.first], maxDepth, currDepth + 1

            if diff.empty?
              seed
            else
              seed.merge({current.first => diff})
            end
          end
        end
      end
    end

    def key_diff(h1, h2)
      key_diff_r h1, h2, 2, 0
    end
  end
end
