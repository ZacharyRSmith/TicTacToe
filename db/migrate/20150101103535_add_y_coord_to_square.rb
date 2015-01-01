class AddYCoordToSquare < ActiveRecord::Migration
  def change
    add_column :squares, :y_coord, :int
  end
end
