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
      loaded = Overcommit::ConfigurationLoader.load_from_file('.overcommit.yml').plugin_directory
      WrongGithooksWorkaround.fix_plugin_dir loaded
    end

    def hooks_dirs
      config['hooks_dirs'] || ['hooks', 'meta-hooks']
    end
  end
end

# Can get rid of this when this issue is solved
# https://github.com/brigade/overcommit/pull/234
class WrongGithooksWorkaround
  def self.fix_plugin_dir(path)
    if path =~ /\.githooks$/
      Dir.exists?(path) ? path : get_correct_default(path)
    else
      path
    end
  end

  private

  def self.get_correct_default(path)
    dir_name = File.dirname(path)
    if dir_name =~ /\w/
      "#{dir_name}/.git-hooks"
    else
      ".git-hooks"
    end
  end
end
