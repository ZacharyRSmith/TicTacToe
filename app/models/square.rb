class Square < ActiveRecord::Base
  belongs_to :board
  has_and_belongs_to_many :lines

  def get_coords_str
    coords_str = self.x_coord.to_s + "-" +
                 self.y_coord.to_s + "-" +
                 self.z_coord.to_s
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
  end
end
