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
          square.reset_lines("X")
          square.reset_associated_ai_priorities()
          square.save

          # Computer marks a random unmarked square.
          max_priority = @board.squares.where(mark: "_").maximum("ai_priority")
          ai_square = @board.squares.where(mark: "_").where(ai_priority: max_priority).sample
          ai_square.mark = "O"
          ai_square.reset_lines("O")
          ai_square.reset_associated_ai_priorities()
          ai_square.save

#           unmarked_squares_ary = @board.squares.where(mark: "_")
#           ai_square = unmarked_squares_ary.sample
#           ai_square.mark = "O"
#           ai_square.save

          f.js {
            @ai_square_coords_str = ai_square.get_coords_str()
            @alert = "You did not click on an already-marked square. Look at you!"
            @coords_str = square.get_coords_str()
            @scores_ary = @board.get_scores()
          }
        end
      else
        f.html {
          @board = Board.create!({ size: 3 })
          @lyrs = @board.init_lyrs_ary()
        }
      end
    end
  end
end
