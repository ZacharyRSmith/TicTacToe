class BoardsController < ApplicationController
  def index
    respond_to do |f|
      if request.xhr?
        @board = Board.find(params[:board_id])
        coordsIntAry = params[:coordsIntAry]
        x = coordsIntAry[0].to_i
        y = coordsIntAry[1].to_i
        z = coordsIntAry[2].to_i
        square = @board.squares.find(@board.squares_id_ary[x][y][z])
        square.mark = "X"
        square.save

        unmarked_squares_ary = @board.squares.where(mark: "_")
        ai_square = unmarked_squares_ary.sample
        ai_square.mark = "O"
        ai_square.save

        f.js {
          @ai_square_coords_str = ai_square.get_coords_str()
          @coords_str = square.get_coords_str()
        }
      else
        f.html {
          @board = Board.create!({ size: 2 })
          @lyrs = @board.init_lyrs_ary()
        }
      end
    end
  end
end
