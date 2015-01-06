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

    board = Board.create!({ size: 2 })
    assert_equal 28, board.lines.count
  end
end
