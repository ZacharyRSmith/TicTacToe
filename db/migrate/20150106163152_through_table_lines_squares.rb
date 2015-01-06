class ThroughTableLinesSquares < ActiveRecord::Migration
  def change
    create_table :lines_squares, id: false do |t|
      t.belongs_to :line, index: true
      t.belongs_to :square, index: true
    end
  end
end
