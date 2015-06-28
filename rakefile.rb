require 'rake/testtask'

task :default => [:test]

Rake::TestTask.new do |t|
  t.test_files = FileList['**/*_test.rb']
  t.verbose = true
end

namespace :hooks do
  desc 'Copies all hooks in `hooks/` to `.git-hooks/`'
  task :install do
    git_hooks = Dir.chdir(".git-hooks"){ Dir.pwd }

    Dir.chdir "hooks" do
      Dir.glob "**/*.rb" do |path|
        cp_r path, "#{git_hooks}/#{path}"
      end
    end
  end
end
