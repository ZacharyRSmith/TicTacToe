require 'test_helper'

class BoardTest < ActiveSupport::TestCase
  test "a 2x2x2 board should have 24 unique lines" do
    assert_equal boards(:b).gen_lines().uniq.count, 24
  end
end
