class Board < ActiveRecord::Base
  belongs_to :game
  has_many :lines
  has_many :squares
  serialize :squares_id_ary
  serialize :lines
  
  after_create do
    # This save is needed to create board.id
    self.save
    self.gen_squares_id_ary
    # This save is needed so that self has squares_id_ary
    self.save
    self.gen_lines
    self.set_lines_on_squares

    # If board size-length is uneven, make middle square un-useable
    # (because it would give excessive advantage to the beginning player):
    if self.size % 2 != 0
      mid = (self.size-1) / 2
      sqr = self.squares.find(self.squares_id_ary[mid][mid][mid])
      sqr.mark = "~"
      sqr.save
    end

    self.save
  end
  
  def get_scores
    marked_lines = self.lines.select do |ln|
      ln.squares.any? do |square|
        square = self.squares.find(square)
        square.mark != "_"
      end
    end

    x_score = 0
    o_score = 0
    marked_lines.each do |ln|
      if ln.all? do |sqr_id|
          sqr = self.squares.find(sqr_id)
          sqr.mark == "X"
        end
        x_score += 1
      elsif ln.all? do |sqr_id|
          sqr = self.squares.find(sqr_id)
          sqr.mark == "O"
        end
        o_score += 1
      end
    end

    [x_score, o_score]
  end

  def add_line(squares_id_ary)
    line = self.lines.create!({ status: "unmarked" })
    squares_id_ary.each do |sqr_id|
      sqr = self.squares.find(sqr_id)
      line.squares << sqr
    end
  end

  def gen_lines
    # COLUMNS:
    for x_coord in 0..self.size-1
      for z_coord in 0..self.size-1
        squares_id_ary = []
        for y_coord in 0..self.size-1
          squares_id_ary << self.squares_id_ary[x_coord][y_coord][z_coord]
        end

        self.add_line(squares_id_ary)
      end
    end

    # ROWS:
    for y_coord in 0..self.size-1
      for z_coord in 0..self.size-1
        squares_id_ary = []
        for x_coord in 0..self.size-1
          squares_id_ary << self.squares_id_ary[x_coord][y_coord][z_coord]
        end

        self.add_line(squares_id_ary)
      end
    end

    # HILLS:
    for x_coord in 0..self.size-1
      for y_coord in 0..self.size-1
        squares_id_ary = []
        for z_coord in 0..self.size-1
          squares_id_ary << self.squares_id_ary[x_coord][y_coord][z_coord]
        end

        self.add_line(squares_id_ary)
      end
    end

    # DIAGONALS:
    # On the same z-plane/layer:
    for z_coord in 0..self.size-1

      squares_id_ary = []
      for x_coord in 0..self.size-1
        y_coord = x_coord
        squares_id_ary << self.squares_id_ary[x_coord][y_coord][z_coord]
      end
      self.add_line(squares_id_ary)

      squares_id_ary = []
      for x_coord in (self.size-1).downto(0)
        y_coord = (self.size-1) - x_coord
        squares_id_ary << self.squares_id_ary[x_coord][y_coord][z_coord]
      end
      self.add_line(squares_id_ary)
    end

    # Diagonal-columns at coords (x, 0, 0):
    for x_coord in 0..self.size-1
      squares_id_ary = []
      for i_coord in 0..self.size-1
        squares_id_ary << self.squares_id_ary[x_coord][i_coord][i_coord]
      end
      self.add_line(squares_id_ary)
    end
    # Diagonal-columns at coords (x, 0, greatest):
    for x_coord in 0..self.size-1
      squares_id_ary = []
      for z_coord in (self.size-1).downto(0)
        y_coord = (self.size-1) - z_coord
        squares_id_ary << self.squares_id_ary[x_coord][y_coord][z_coord]
      end
      self.add_line(squares_id_ary)
    end

    # Diagonal-rows at coords (0, y, 0):
    for y_coord in 0..self.size-1
      squares_id_ary = []
      for i_coord in 0..self.size-1
        squares_id_ary << self.squares_id_ary[i_coord][y_coord][i_coord]
      end
      self.add_line(squares_id_ary)
    end
    # Diagonal-rows at coords (0, y, greatest):
    for y_coord in 0..self.size-1
      squares_id_ary = []
      for i_coord in (self.size-1).downto(0)
        x_coord = (self.size-1) - i_coord
        squares_id_ary << self.squares_id_ary[x_coord][y_coord][i_coord]
      end
      self.add_line(squares_id_ary)
    end

    # Corner diagonals (diagonals that go through the center of the box):
    # at coords (0,0,0)
    squares_id_ary = []
    for i_coord in 0..self.size-1
      squares_id_ary << self.squares_id_ary[i_coord][i_coord][i_coord]
    end
    self.add_line(squares_id_ary)

    # at coords (0, 0, greatest)
    squares_id_ary = []
    for i_coord in 0..self.size-1
      z_coord = (self.size-1) - i_coord
      squares_id_ary << self.squares_id_ary[i_coord][i_coord][z_coord]
    end
    self.add_line(squares_id_ary)

    # at coords (greatest, 0, 0)
    squares_id_ary = []
    for i_coord in 0..self.size-1
      x_coord = (self.size-1) - i_coord
      squares_id_ary << self.squares_id_ary[x_coord][i_coord][i_coord]
    end
    self.add_line(squares_id_ary)

    # at coords (greatest, 0, greatest)
    squares_id_ary = []
    for y_coord in 0..self.size-1
      i_coord = (self.size-1) - y_coord
      squares_id_ary << self.squares_id_ary[i_coord][y_coord][i_coord]
    end
    self.add_line(squares_id_ary)

    # If board side-length is uneven, remove lines containing middle-square.
    if self.size % 2 != 0
      mid = (self.size-1) / 2

      middle_square_id = self.squares_id_ary[mid][mid][mid]
      self.lines = self.lines.keep_if do |ln|
        ln.squares.all? { |square| square.id != middle_square_id }
      end
    end
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
  
  def set_lines_on_squares
    self.squares.each do |sqr|
      lines = self.lines.select do |ln|
        ln.squares.any? { |ln_sqr| ln_sqr == sqr }
      end
      sqr.lines = lines
    end
  end

end
