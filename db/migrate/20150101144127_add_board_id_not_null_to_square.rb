class AddBoardIdNotNullToSquare < ActiveRecord::Migration
  def change
    change_column_null(:squares, :board_id, false)
  end
end
