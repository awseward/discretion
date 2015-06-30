require 'git'
require 'overcommit'

module Overcommit::Hook::PrePush
  class PrintDiffUrls < Base
    def description
      super_desc = super
      begin
        get_description super_desc
      rescue Exception => ex
        @exception = ex
        super_desc
      end
    end

    def run
      if defined?(@exception)
        messages = [
          "",
          "#{self.class} raised an error: #{@exception.message}",
          "",
          @exception.backtrace.map{|str| "  #{str}"},
          "",
        ]

        [:warn, messages.join("\n")]
      else
        :pass
      end
    end

    private

    def get_description(super_desc)
      git = Git.open(Dir.pwd)
      branch = git.current_branch

      @config['description'] || format_description(super_desc, branch, git.remotes)
    end

    def format_description(super_desc, branch, remotes)
      if remotes.size == 1
        formatted_remotes = "  #{GitUrlFormat.compare_url remotes.first.url, branch}"
      else
        formatted_remotes = remotes.map{ |r| "  #{format_remote r, branch}" }.join "\n"
      end

      [super_desc, formatted_remotes, ''].join "\n"
    end

    def format_remote(remote, branch)
      "#{remote.name}: #{GitUrlFormat.compare_url remote.url, branch}"
    end
  end
end

class GitUrlFormat
  def self.format_base_url(url)
    coerce_scheme url
  end

  def self.compare_url(url, branch)
    master_compare format_base_url(url), branch
  end

  private

  def self.master_compare(url, branch)
    branch_compare url, 'master', branch
  end

  def self.branch_compare(url, base, branch)
    "#{url}/compare/#{base}...#{branch}"
  end

  def self.is_ssh(url)
    url.match /^.*@.+:.+$/
  end

  def self.ssh_to_https(url)
    host, path = url.match(/^.*@(.+):(.+).git/).captures
    "https://#{host}/#{path}"
  end

  def self.coerce_scheme(url)
    if is_ssh(url)
      ssh_to_https url
    else
      url
    end
  end
end
