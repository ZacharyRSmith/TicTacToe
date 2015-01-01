class AddSquaresIdAryToBoard < ActiveRecord::Migration
  def change
    add_column :boards, :squares_id_ary, :string
  end
end
