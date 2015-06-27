require 'git'

module Overcommit::Hook::PrePush
  class PrintDiffUrls < Base
    def description
      super_desc = super
      begin
        get_description super_desc
      rescue
        super_desc
      end
    end

    def run
      :pass
    end

    private

    def get_description(super_desc)
      git = Git.open(Dir.pwd)
      branch = git.current_branch

      @config['description'] || format_description(super_desc, branch, git.remotes)
    end

    def format_description(super_desc, branch, remotes)
      if remotes.size == 1
        formatted_remotes = "  #{format_url remotes[0].url, branch}"
      else
        formatted_remotes = remotes.map{ |r| "  #{format_remote r, branch}" }.join "\n"
      end

      [super_desc, formatted_remotes, ''].join "\n"
    end

    def is_ssh(url)
      url.match /^.*@.+:.+$/
    end

    def ssh_to_https(url)
      host, path = url.match(/^.*@(.+):(.+).git/).captures
      "https://#{host}/#{path}"
    end

    def format_remote(remote, branch)
      "#{remote.name}: #{format_url remote.url, branch}"
    end

    def coerce_scheme(url)
      if is_ssh(url)
        ssh_to_https url
      else
        url
      end
    end

    def branch_compare(url, base, branch)
      "#{url}/compare/#{base}...#{branch}"
    end

    def master_compare(url, branch)
      branch_compare url, 'master', branch
    end

    def format_url(url, branch)
      master_compare coerce_scheme(url), branch
    end
  end
end
