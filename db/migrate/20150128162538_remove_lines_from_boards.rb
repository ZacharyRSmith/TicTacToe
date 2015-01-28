class RemoveLinesFromBoards < ActiveRecord::Migration
  def change
    remove_column :boards, :lines, :string
  end
end
