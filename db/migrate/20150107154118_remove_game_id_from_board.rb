class RemoveGameIdFromBoard < ActiveRecord::Migration
  def change
    remove_column :boards, :game_id, :integer
  end
end
