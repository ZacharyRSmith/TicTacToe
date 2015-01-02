class AddSizeToBoard < ActiveRecord::Migration
  def change
    add_column :boards, :size, :integer
  end
end
