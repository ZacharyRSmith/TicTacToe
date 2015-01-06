class Board < ActiveRecord::Base
  belongs_to :game
  has_many :squares
  serialize :squares_id_ary
  
  serialize :lines
  
  after_initialize do
    # FIXME This does not allow for a board to be init'd without saving!
    # This save is needed to create board.id
    self.save
    self.gen_squares_id_ary
    self.gen_lines
    self.save
  end
  
#   def check_victory
#     marked_lines = self.lines.select do |ln|
#       ln.any? { |square| square.mark != "_" }
#     end

#     victory_lines = marked_lines.select do |ln|
#       ln.all? { |square| square.mark == "X" }
#     end

#     if victory_lines.count > 0
#       return true
#     else
#       return false
#     end
#   end

  def gen_lines
    lines = []

    # COLUMNS:
    for x_coord in 0..self.size-1
      for z_coord in 0..self.size-1
        column = []
        for y_coord in 0..self.size-1
          column << self.squares_id_ary[x_coord][y_coord][z_coord]
        end
        lines << column
      end
    end

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

#     lines
    
    self.lines = lines
  end

  def gen_squares_id_ary()
    self.squares_id_ary = []
    for x_coord in 0..self.size-1
      column = []
      for y_coord in 0..self.size-1
        hill = []
        # A "hill" is the line containing all the z_coords
        # sharing the same x/y-coords.
        for z_coord in 0..self.size-1
          square = self.squares.create!({x_coord: x_coord, y_coord: y_coord,
                                         z_coord: z_coord, mark: "_" })
          hill << square.id
        end
        column << hill
      end
      squares_id_ary << column
    end
    self.squares_id_ary
  end

  def init_lyrs_ary
    lyrs = []
    for x in 0..self.size-1
      for y in 0..self.size-1
        for z in 0..self.size-1
          lyrs[z] ||= []
          lyrs[z][y] ||= []
          lyrs[z][y] << self.squares_id_ary[x][y][z]
        end
      end
    end
    lyrs
  end
end
