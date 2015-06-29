require 'overcommit'

module Overcommit::Hook::PreCommit
  class EatYourDogfood < Base
    def description
      "Checking that you're eating your dog food"
    end

    def run
      src_hooks = hooks_dirs.map do |dir|
        Dir.chdir dir do
          Dir.glob "**/*.rb"
        end
      end.flatten

      dest_hooks = Dir.chdir plugin_dir do
        Dir.glob "**/*.rb"
      end

      missing_hooks = src_hooks - dest_hooks

      if missing_hooks.any?
        messages = [
          "The following hooks are missing from #{plugin_dir}",
          missing_hooks.map{|h| "  #{h}"}.join("\n"),
        ]

        [:warn, messages.join("\n")]
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
  end
end
