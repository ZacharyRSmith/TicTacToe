require 'test_helper'

class SquareTest < ActiveSupport::TestCase
  should validate_presence_of(:board_id)
  should validate_presence_of(:x_coord)
  should validate_presence_of(:y_coord)
  should validate_presence_of(:z_coord)
  should validate_presence_of(:mark)

  def setup
    @board = Board.create!({ size: 2 })
  end

  test "square.lines should be correct count" do
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
