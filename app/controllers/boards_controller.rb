class BoardsController < ApplicationController
  def index
    respond_to do |f|
      if request.xhr?
        @board = Board.find(params[:board_id])

        # Mark the square that was clicked.
        coordsIntAry = params[:coordsIntAry]
        x = coordsIntAry[0].to_i
        y = coordsIntAry[1].to_i
        z = coordsIntAry[2].to_i
        square = @board.squares.find(@board.squares_id_ary[x][y][z])
        if square.mark != "_"
          f.js { @alert = "That square is already taken!\n" +
                          "Click on another square." }
        else
          square.mark = "X"
          square.save

          # Computer marks a random unmarked square.
          unmarked_squares_ary = @board.squares.where(mark: "_")
          ai_square = unmarked_squares_ary.sample
          ai_square.mark = "O"
          ai_square.save

          f.js {
            @ai_square_coords_str = ai_square.get_coords_str()
            @alert = "Foo"
            @coords_str = square.get_coords_str()
            @scores_ary = @board.get_scores()
          }
        end
      else
        f.html {
          @board = Board.create!({ size: 2 })
          @lyrs = @board.init_lyrs_ary()
        }
      end
    end
  end
end
