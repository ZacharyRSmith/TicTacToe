class AddIndecesToSquare < ActiveRecord::Migration
  def change
    add_index :squares, :x_coord
    add_index :squares, :y_coord
    add_index :squares, :z_coord
  end
end
