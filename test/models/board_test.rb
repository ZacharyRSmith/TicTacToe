require 'test_helper'

class BoardTest < ActiveSupport::TestCase
  def setup
    @board = Board.create!({ size: 2 })
  end

  test "board.lines and square.lines should be correct count" do
    # 4 each of:
    # columns
    # diagonal-columns
    # rows
    # diagonal-rows
    # diagonals
    # diagonal-diagonals
    # hills

#     board = Board.create!({ size: 2 })
    assert_equal 28, @board.lines.count

    sqr = @board.squares.find(@board.squares_id_ary[0][0][0])
    assert_equal 7, sqr.lines.count
  end

  
  test "square should have correct self.ai_priority" do
    board = Board.create!({ size: 3 })

    sqr = board.squares.find(board.squares_id_ary[0][0][0])
    sqr.set_ai_priority()
    sqr.save
    assert_equal 12, sqr.ai_priority
  end
end
