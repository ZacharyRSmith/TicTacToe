require 'test_helper'

class BoardTest < ActiveSupport::TestCase
  test "a 2x2x2 board should have 28 unique lines" do
    # 4 each of:
    # columns
    # diagonal-columns
    # rows
    # diagonal-rows
    # diagonals
    # diagonal-diagonals
    # hills
    
    lines = boards(:b).gen_lines()
    lines = lines.each { |ln| ln.sort! }
    assert_equal 28, lines.uniq.count
  end
end
