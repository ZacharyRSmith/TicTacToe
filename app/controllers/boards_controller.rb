class BoardsController < ApplicationController
  def index
    @board = Board.last

    respond_to do |f|
      if request.xhr?
        coordsIntAry = params[:coordsIntAry]
        x = coordsIntAry[0].to_i
        y = coordsIntAry[1].to_i
        z = coordsIntAry[2].to_i
        square = @board.squares.find(@board.squares_id_ary[x][y][z])
        square.mark = "X"
        @new_mark = square.mark

        @coordsStr = x.to_s + "-" + y.to_s + "-" + z.to_s

        f.js {}
      else
        f.html { @lyrs = Board.last.init_lyrs_ary() }
      end
    end
  end
end
