class BoardsController < ApplicationController
  def index
    respond_to do |f|
      if !request.xhr?
        f.html { @board = Board.create!({ size: 3 })
                 @layers = @board.init_layers_ary() }
        # This "next" is a hacky way to allow this "filter/Guard Pattern".
        next
      end

      @board = Board.find(params[:board_id])
      # Mark the square that was clicked.
      coords_int_ary = params[:coordsIntAry]
      x = coords_int_ary[0].to_i
      y = coords_int_ary[1].to_i
      z = coords_int_ary[2].to_i
      square = @board.squares.find(@board.squares_id_ary[x][y][z])
      if square.mark != "_"
        f.js { render :file => "boards/bad_click.js.erb" }
        # This "next" is a hacky way to allow this "filter/Guard Pattern".
        next
      end

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

      f.js { @ai_square_coords_str = ai_square.get_coords_str()
             @coords_str = square.get_coords_str()
             @scores_ary = @board.get_scores() }
    end
  end
end
