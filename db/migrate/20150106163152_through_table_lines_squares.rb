class ThroughTableLinesSquares < ActiveRecord::Migration
  def change
    create_table :lines_squares, id: false do |t|
      t.belongs_to :lines, index: true
      t.belongs_to :squares, index: true
    end
  end
end
