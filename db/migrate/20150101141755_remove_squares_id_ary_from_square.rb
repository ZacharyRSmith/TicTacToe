class RemoveSquaresIdAryFromSquare < ActiveRecord::Migration
  def change
    remove_column :squares, :squares_id_ary, :string
  end
end
