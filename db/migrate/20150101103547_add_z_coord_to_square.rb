class AddZCoordToSquare < ActiveRecord::Migration
  def change
    add_column :squares, :z_coord, :int
  end
end
