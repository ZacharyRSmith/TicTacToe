class AddAiPriorityToSquare < ActiveRecord::Migration
  def change
    add_column :squares, :ai_priority, :integer
    add_index :squares, :ai_priority
  end
end
