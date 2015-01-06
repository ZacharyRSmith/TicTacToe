class AlterMarkInSquares < ActiveRecord::Migration
  def change
    add_index :squares, :mark
    change_column_null(:squares, :mark, false)
  end
end
