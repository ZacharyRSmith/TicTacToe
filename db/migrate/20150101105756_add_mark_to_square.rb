class AddMarkToSquare < ActiveRecord::Migration
  def change
    add_column :squares, :mark, :string
  end
end
