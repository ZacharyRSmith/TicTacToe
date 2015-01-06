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

        if @board.victory?
          @victory = true
        else
          @victory = false
        end

        f.js {
          @coordsStr = x.to_s + "-" + y.to_s + "-" + z.to_s
          @new_mark = square.mark
          @victory
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
