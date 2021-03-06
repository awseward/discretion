require 'minitest/autorun'
require 'overcommit'
require 'overcommit/hook/pre_push/base'
require 'uri'
require './hooks/pre_push/print_diff_urls'

class TestDiffUrls < Minitest::Test
  def setup
    @ssh_url = "git@github.com:awseward/overcommit-hooks.git"
  end

  def test_base_url_formatting
    http_url = GitUrlFormat.format_base_url @ssh_url

    assert http_url =~ URI::regexp
  end

  def test_compare_url_formatting
    branch = "some_feature_branch"
    compare_url = GitUrlFormat.compare_url @ssh_url, branch

    assert compare_url =~ URI::regexp
  end
end
