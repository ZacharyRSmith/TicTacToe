class AddLinesToBoard < ActiveRecord::Migration
  def change
    add_column :boards, :lines, :string
  end
end
