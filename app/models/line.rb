class Line < ActiveRecord::Base
  has_and_belongs_to_many :squares
  belongs_to :board

  def set_status_as_scored
    self.status = "non_scoreable"
  end

  def set_status(new_mark)
    if (new_mark != "X" && new_mark != "O")
      self.status = "non_scoreable"
    else
      case self.status
      when "unmarked"
        if new_mark == "X"
          self.status = "x_scoreable"
        else
          self.status = "o_scoreable"
        end
      when "x_scoreable"
        if new_mark == "O"
          self.status = "non_scoreable"
        end
      when "o_scoreable"
        if new_mark == "X"
          self.status = "non_scoreable"
        end
      end
    end
    self.save
  end
end
