require 'overcommit'

module Overcommit::Hook::PreCommit
  class EatYourDogfood < Base
    def description
      "Checking for missing plugins"
    end

    def run
      src_hooks = get_src_hook_info.map do |info|
        info[:rel_paths]
      end.flatten

      missing = src_hooks - get_existing_dest_hooks

      if missing.any?
        messages = [
          "The following hooks are missing from #{plugin_dir}",
          missing.map{|h| "  #{h}"}.join("\n"),
        ]

        [:fail, messages.join("\n")]
      else
        :pass
      end
    end

    private

    def plugin_dir
      PluginDirectoryWorkaround.get_plugin_dir
    end

    def hooks_dirs
      config['hooks_dirs'] || ['hooks', 'meta-hooks']
    end

    def get_src_hook_info
      DogfoodServiceObject.get_source_hook_info hooks_dirs
    end

    def get_existing_dest_hooks
      DogfoodServiceObject.get_existing_dest_hooks plugin_dir
    end
  end
end
