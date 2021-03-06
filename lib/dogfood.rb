require 'overcommit'

class DogfoodServiceObject
  def self.get_source_hook_info(src_dirs)
    src_dirs.map do |dir|
      rel_paths = Dir.chdir(dir){ Dir.glob "**/*.rb" }

      { :src_dir => dir, :rel_paths => rel_paths }
    end
  end

  def self.get_existing_dest_hooks(plugin_dir)
    Dir.chdir(plugin_dir){ Dir.glob '**/*.rb' }
  end
end

# Can get rid of this when this issue is solved
# https://github.com/brigade/overcommit/pull/234
class PluginDirectoryWorkaround
  def self.get_plugin_dir
    loader = Overcommit::ConfigurationLoader
    loaded = loader.load_from_file('.overcommit.yml').plugin_directory
    fix_plugin_dir loaded
  end

  private

  def self.fix_plugin_dir(path)
    if path =~ /\.githooks$/
      Dir.exists?(path) ? path : get_correct_default(path)
    else
      path
    end
  end

  def self.get_correct_default(path)
    dir_name = File.dirname(path)
    if dir_name =~ /\w/
      "#{dir_name}/.git-hooks"
    else
      ".git-hooks"
    end
  end
end

