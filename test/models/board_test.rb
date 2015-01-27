require 'test_helper'

class BoardTest < ActiveSupport::TestCase
  def setup
    @board = Board.create!({ size: 2 })
  end

  test "board.lines should be correct count" do
    assert_equal 28, @board.lines.count
  end
end
