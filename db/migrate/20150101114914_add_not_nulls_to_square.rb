class AddNotNullsToSquare < ActiveRecord::Migration
  def change
    change_column_null(:squares, :x_coord, false)
    change_column_null(:squares, :y_coord, false)
    change_column_null(:squares, :z_coord, false)
  end
end
