class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.string :status

      t.timestamps null: false
    end
  end
end
