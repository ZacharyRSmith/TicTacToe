class Game < ActiveRecord::Base
  has_one :board

  def initialize()
    # @board = Board.new(size)
    # @crnt_player = "X"
  end

  def check_victory()
    # look at last marked cell.
  end
end
