require 'minitest/autorun'
require 'overcommit'
require 'overcommit/hook/pre_push/base'
require './hooks/pre_push/print_diff_urls'

class TestDiffUrls < Minitest::Test
  def setup
    @formatter = GitRemoteUrlFormatter.new
  end

  def test_example
    assert_equal 1, 0
  end
end
