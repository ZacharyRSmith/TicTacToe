class RemoveSquaresIdAryFromBoards < ActiveRecord::Migration
  def change
    remove_column :boards, :squares_id_ary, :string
  end
end
