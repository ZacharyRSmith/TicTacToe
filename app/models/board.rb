class Board < ActiveRecord::Base
  # See db/doc_schema.rb for property documentation.
  has_many :lines
  has_many :squares

  after_create do
    # This save is needed to create board.id
    self.save()
    self.gen_squares()
    self.gen_lines()
    self.set_lines_on_squares()
    # board#reset_mid_sqr_lines makes middle square un-useable
    # (because it would give excessive advantage to the beginning player)
    self.reset_mid_sqr_lines()
    self.squares.each { |sqr| sqr.set_ai_priority() }

    self.save
  end

  def get_scores()
    marked_lines = self.lines.where!(status: "unmarked")

    x_score = 0
    o_score = 0
    marked_lines.each do |ln|
      if ln.squares.all? do |sqr|
          sqr.mark == "X"
        end
        ln.set_status_as_scored
        x_score += 1
      elsif ln.squares.all? do |sqr|
          sqr.mark == "O"
        end
        ln.set_status_as_scored
        o_score += 1
      end
    end

    [x_score, o_score]
  end

  def add_line(squares_ary)
    line = self.lines.create!({ status: "unmarked" })
    squares_ary.each do |sqr|
      line.squares << sqr
    end
  end

  def gen_lines()
    self.gen_straight_lines()

    # DIAGONALS:
    # On the same z-plane/layer:
    for z in 0..self.size-1

      squares_ary = []
      for x in 0..self.size-1
        y = x
        squares_ary << self.squares.where(x_coord: x, y_coord: y, z_coord: z)
      end
      self.add_line(squares_ary)

      squares_ary = []
      for x in (self.size-1).downto(0)
        y = (self.size-1) - x
        squares_ary << self.squares.where(x_coord: x, y_coord: y, z_coord: z)
      end
      self.add_line(squares_ary)
    end

    # Diagonal-columns at coords (x, 0, 0):
    for x in 0..self.size-1
      squares_ary = []
      for i in 0..self.size-1
        squares_ary << self.squares.where(x_coord: x, y_coord: i, z_coord: i)
      end
      self.add_line(squares_ary)
    end
    # Diagonal-columns at coords (x, 0, greatest):
    for x in 0..self.size-1
      squares_ary = []
      for z in (self.size-1).downto(0)
        y = (self.size-1) - z
        squares_ary << self.squares.where(x_coord: x, y_coord: y, z_coord: z)
      end
      self.add_line(squares_ary)
    end

    # Diagonal-rows at coords (0, y, 0):
    for y in 0..self.size-1
      squares_ary = []
      for i in 0..self.size-1
        squares_ary << self.squares.where(x_coord: i, y_coord: y, z_coord: i)
      end
      self.add_line(squares_ary)
    end
    # Diagonal-rows at coords (0, y, greatest):
    for y in 0..self.size-1
      squares_ary = []
      for z in (self.size-1).downto(0)
        x = (self.size-1) - z
        squares_ary << self.squares.where(x_coord: x, y_coord: y, z_coord: z)
      end
      self.add_line(squares_ary)
    end

    # Corner diagonals (diagonals that go through the center of the box):
    # at coords (0,0,0)
    squares_ary = []
    for i in 0..self.size-1
      squares_ary << self.squares.where(x_coord: i, y_coord: i, z_coord: i)
    end
    self.add_line(squares_ary)

    # at coords (0, 0, greatest)
    squares_ary = []
    for i in 0..self.size-1
      z = (self.size-1) - i
      squares_ary << self.squares.where(x_coord: i, y_coord: i, z_coord: z)
    end
    self.add_line(squares_ary)

    # at coords (greatest, 0, 0)
    squares_ary = []
    for i in 0..self.size-1
      x = (self.size-1) - i
      squares_ary << self.squares.where(x_coord: x, y_coord: i, z_coord: i)
    end
    self.add_line(squares_ary)

    # at coords (greatest, 0, greatest)
    squares_ary = []
    for y in 0..self.size-1
      i = (self.size-1) - y
      squares_ary << self.squares.where(x_coord: i, y_coord: y, z_coord: i)
    end
    self.add_line(squares_ary)
  end

  def gen_squares()
    for x in 0..self.size-1
      for y in 0..self.size-1
        for z in 0..self.size-1
          self.squares.create!({x_coord: x, y_coord: y,
                                z_coord: z, mark: "_" })
        end
      end
    end
  end

  def gen_straight_lines()
    for i in 0..self.size-1
      for j in 0..self.size-1
        column = []
        row    = []
        hill   = []
        for k in 0..self.size-1
          column << self.squares.where(x_coord: i, y_coord: k, z_coord: j)
          row    << self.squares.where(x_coord: k, y_coord: i, z_coord: j)
          hill   << self.squares.where(x_coord: i, y_coord: j, z_coord: k)
        end

        self.add_line(column)
        self.add_line(row)
        self.add_line(hill)
      end
    end
  end

  def init_layers_ary()
    layers = []
    for x in 0..self.size-1
      for y in 0..self.size-1
        for z in 0..self.size-1
          layers[z] ||= []
          layers[z][y] ||= []

          layers[z][y] << self.squares.find_by(x_coord: x, y_coord: y,
                                               z_coord: z)
        end
      end
    end
    layers
  end

  def reset_mid_sqr_lines()
    # If board size-length is uneven, make middle square un-useable
    # (because it would give excessive advantage to the beginning player):
    if self.size % 2 != 0
      mid = (self.size-1) / 2
      
      sqr = self.squares.find_by(x_coord: mid, y_coord: mid, z_coord: mid)
      sqr.mark = "~"
      sqr.reset_lines("~")
      sqr.save
    end
  end

  def set_lines_on_squares()
    self.squares.each do |sqr|
      lines = self.lines.select do |ln|
        ln.squares.any? { |ln_sqr| ln_sqr == sqr }
      end
      sqr.lines = lines
    end
  end
end
