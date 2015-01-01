class AddXCoordToSquare < ActiveRecord::Migration
  def change
    add_column :squares, :x_coord, :int
  end
end
