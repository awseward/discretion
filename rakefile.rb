require 'fileutils'
require 'rake/testtask'

task :default => [:test]

Rake::TestTask.new do |t|
  t.test_files = FileList['**/*_test.rb']
  t.verbose = true
end

namespace :hooks do
  desc 'Copies all hooks in `hooks/` to `.git-hooks/`'
  task :install do
    plugin_directory = ".git-hooks"
    src_hooks_dirs = ["hooks", "meta-hooks"]

    if !Dir.exists?(plugin_directory)
      mkdir plugin_directory
    end

    git_hooks = Dir.chdir(plugin_directory){ Dir.pwd }

    src_hooks_dirs.each do |hook_dir|
      Dir.chdir hook_dir do
        Dir.glob "**/*.rb" do |path|
          dest = "#{git_hooks}/#{path}"

          dest_dir = File.dirname dest
          FileUtils.mkdir_p(dest_dir) if !Dir.exists? dest_dir

          cp_r path, dest
        end
      end
    end
  end

  desc 'Signs all overcommit hooks'
  task :sign do
    hook_types = [
      'commit_msg',
      'post_checkout',
      'post_commit',
      'post_merge',
      'post_rewrite',
      'pre_commit',
      'pre_push',
      'pre_rebase',
    ]

    hook_types.each do |type|
      sh "overcommit --sign #{type}"
    end
  end
end
