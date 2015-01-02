class Board < ActiveRecord::Base
  belongs_to :game
  has_many :squares
  serialize :squares_id_ary

  def build_non_diag_lines(lines, coords_order)
    for i in 0..self.size-1
      for j in 0..self.size-1
        line = []
        for k in 0..self.size-1
          case coords_order[0]
          when "i"
            if (coords_order[1] == "j")
              line << self.squares_id_ary[i][j][k]
            else
              line << self.squares_id_ary[i][k][j]
            end
          when "j"
            if (coords_order[1] == "i")
              line << self.squares_id_ary[j][i][k]
            else
              line << self.squares_id_ary[j][k][i]
            end
          when "k"
            if (coords_order[1] == "i")
              line << self.squares_id_ary[k][i][j]
            else
              line << self.squares_id_ary[k][j][i]
            end
          end
        end
        lines << line
      end
    end
    lines
  end

  def build_non_diag_lines_hardcode(lines)
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

  def gen_lines
    lines = []

    # COLUMNS:
    lines = self.build_non_diag_lines(lines, ["i", "k"])
    
#     for x_coord in 0..self.size-1
#       for z_coord in 0..self.size-1
#         column = []
#         for y_coord in 0..self.size-1
#           column << self.squares_id_ary[x_coord][y_coord][z_coord]
#         end
#         lines << column
#       end
#     end

    # ROWS:
    for y_coord in 0..self.size-1
      for z_coord in 0..self.size-1
        row = []
        for x_coord in 0..self.size-1
          row << self.squares_id_ary[x_coord][y_coord][z_coord]
        end
        lines << row
      end
    end

    # HILLS:
#     self.build_non_diag_lines(["x"])
    for x_coord in 0..self.size-1
      for y_coord in 0..self.size-1
        hill = []
        for z_coord in 0..self.size-1
          hill << self.squares_id_ary[x_coord][y_coord][z_coord]
        end
        lines << hill
      end
    end

    # DIAGONALS:
    # Diagonal-columns at coords (x, 0, 0):
    for x_coord in 0..self.size-1
      column = []
      for i_coord in 0..self.size-1
        column << self.squares_id_ary[x_coord][i_coord][i_coord]
      end
      lines << column
    end
    # Diagonal-columns at coords (x, 0, greatest):
    for x_coord in 0..self.size-1
      column = []
      for i_coord in (self.size-1).downto(0)
        column << self.squares_id_ary[x_coord][i_coord][i_coord]
      end
      lines << column
    end

    # Diagonal-rows at coords (0, y, 0):
    for y_coord in 0..self.size-1
      line = []
      for i_coord in 0..self.size-1
        line << self.squares_id_ary[i_coord][y_coord][i_coord]
      end
      lines << line
    end
    # Diagonal-rows at coords (0, y, greatest):
    for y_coord in 0..self.size-1
      line = []
      for i_coord in (self.size-1).downto(0)
        line << self.squares_id_ary[i_coord][y_coord][i_coord]
      end
      lines << line
    end

    # Corner diagonals (diagonals that go through the center of the box):
    # at coords (0,0,0)
    line = []
    for i_coord in 0..self.size-1
      line << self.squares_id_ary[i_coord][i_coord][i_coord]
    end
    lines << line

    # at coords (0, 0, greatest)
    line = []
    for i_coord in 0..self.size-1
      z_coord = (self.size-1) - i_coord
      line << self.squares_id_ary[i_coord][i_coord][z_coord]
    end
    lines << line

    # at coords (greatest, 0, 0)
    line = []
    for i_coord in 0..self.size-1
      x_coord = (self.size-1) - i_coord
      line << self.squares_id_ary[x_coord][i_coord][i_coord]
    end
    lines << line

    # at coords (greatest, 0, greatest)
    line = []
    for y_coord in 0..self.size-1
      i_coord = (self.size-1) - y_coord
      line << self.squares_id_ary[i_coord][y_coord][i_coord]
    end
    lines << line

    lines
  end

  def gen_hills(x_coord, y_coord)
    # A "hill" is the line containing all the z_coords
    # sharing the same x/y-coords.
    hills = []
    for z_coord in 0..self.size-1
      square = self.squares.create!({x_coord: x_coord, y_coord: y_coord,
                                     z_coord: z_coord })
      hills << square.id
    end
    hills
  end

  def gen_squares_id_ary()
    self.squares_id_ary = []
    for x_coord in 0..self.size-1
      column = []
      for y_coord in 0..self.size-1
        column << gen_hills(x_coord, y_coord)
      end
      squares_id_ary << column
    end
    self.squares_id_ary
  end

  def render

  end
end
