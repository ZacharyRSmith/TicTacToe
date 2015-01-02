require 'test_helper'

class BoardTest < ActiveSupport::TestCase
  def gen_non_diag_lines_hardcode(lines)
    for x_coord in 0..self.size-1
      for y_coord in 0..self.size-1
        hill = []
        for z_coord in 0..self.size-1
          hill << self.squares_id_ary[x_coord][y_coord][z_coord]
        end
        lines << hill
      end
    end
    lines
  end

  test "a 2x2x2 board should have 24 lines" do
    assert_equal boards(:b).gen_lines().count, 24
  end

  test "Board#build_non_diag_lines should work" do
    assert_equal boards(:b).build_non_diag_lines([], ["i", "j"]), boards(:b).build_non_diag_lines_hardcode([])
  end
  # test "the truth" do
  #   assert true
  # end
end
