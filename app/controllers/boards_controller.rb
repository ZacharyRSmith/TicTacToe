class BoardsController < ApplicationController
  def index
    @board = Board.last
    @lyrs = Board.last.init_lyrs_ary()
  end
end
