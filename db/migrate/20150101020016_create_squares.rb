class CreateSquares < ActiveRecord::Migration
  def change
    create_table :squares do |t|
      t.references :board, index: true

      t.timestamps null: false
    end
    add_foreign_key :squares, :boards
  end
end
