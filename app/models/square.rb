class Square < ActiveRecord::Base
  # See db/doc_schema.rb for property documentation.
  belongs_to :board
  has_and_belongs_to_many :lines
  validates :board_id, presence: true
  validates :x_coord, presence: true
  validates :y_coord, presence: true
  validates :z_coord, presence: true
  validates :mark, presence: true

  def get_coords_str
    coords_str = self.x_coord.to_s + "-" +
                 self.y_coord.to_s + "-" +
                 self.z_coord.to_s
  end

  def reset_associated_ai_priorities
    self.lines.each do |ln|
      ln.squares.each do |sqr|
        sqr.set_ai_priority()
      end
    end
  end

  def reset_lines(new_mark)
    self.lines.each do |ln|
      ln.set_status(new_mark)
    end
  end

  def set_ai_priority
    priority = 0
    self.lines.each do |ln|
      case ln.status
      when "unmarked"
        priority += 2
      when "non_scoreable"
        priority += 0
      else
        priority += 1
      end
    end
    self.ai_priority = priority
    self.save
  end
end
