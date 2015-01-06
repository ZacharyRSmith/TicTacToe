class AddBoardIdToLines < ActiveRecord::Migration
  def change
    add_reference :lines, :board, index: true
    add_foreign_key :lines, :boards
  end
end
