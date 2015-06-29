require 'overcommit'

module Overcommit::Hook::PreCommit
  class KeepYourDogfoodFresh < Base
    def description
      "Checking for outdated plugins"
    end

    def run
      src_hook_info = get_src_hook_info
      plugin_dir = get_plugin_dir

      paths = src_hook_info.map do |info|
        src_dir = info[:src_dir]

        info[:rel_paths].map do |rel_path|
          src_path = "#{src_dir}/#{rel_path}"
          dest_path = "#{plugin_dir}/#{rel_path}"

          {:src => src_path, :dest => dest_path}
        end
      end.flatten

      bad = paths.select do |p|
        hook_is_bad p[:src], p[:dest]
      end

      if bad.any?
        messages = [
          "The following hooks have gone bad:",
          bad.map{|p| "  #{p[:dest]}"}.join("\n")
        ]

        [:fail, messages.join("\n")]
      else
        :pass
      end
    end

    private

    def get_src_hook_info
      DogfoodServiceObject.get_source_hook_info(['hooks', 'meta-hooks'])
    end

    def get_plugin_dir
      PluginDirectoryWorkaround.get_plugin_dir
    end

    def hook_is_bad(src, dest)
      File.exists?(dest) && !FileUtils.compare_file(src, dest)
    end
  end
end
