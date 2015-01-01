class Board < ActiveRecord::Base
  belongs_to :game
  has_many :squares
  serialize :squares_id_ary

  def gen_row_piece(size, x_coord, y_coord)
    row_piece = []
    for z_coord in 0..size-1
      square = self.squares.create!({x_coord: x_coord, y_coord: y_coord,
                                     z_coord: z_coord })
      row_piece << square.id
    end
    row_piece
  end

  def gen_squares_id_ary(size)
    self.squares_id_ary = []
    for x_coord in 0..size-1
      column = []
      for y_coord in 0..size-1
        column << gen_row_piece(size, x_coord, y_coord)
      end
      squares_id_ary << column
    end
    self.squares_id_ary
  end

  def render
    
  end
end
