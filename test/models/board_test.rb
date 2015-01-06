require 'test_helper'

class BoardTest < ActiveSupport::TestCase
  test "board.lines and square.lines should be correct count" do
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

    sqr = board.squares.find(board.squares_id_ary[0][0][0])
    assert_equal 7, sqr.lines.count
  end
end
