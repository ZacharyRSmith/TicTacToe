require 'test_helper'

class SquareTest < ActiveSupport::TestCase
  should validate_presence_of(:board_id)
  should validate_presence_of(:x_coord)
  should validate_presence_of(:y_coord)
  should validate_presence_of(:z_coord)
  should validate_presence_of(:mark)
end
