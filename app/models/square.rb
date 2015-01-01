class Square < ActiveRecord::Base
  belongs_to :board

  def initialize([x_coord, y_coord, z_coord])
    self.x_coord = x_coord
    self.y_coord = y_coord
    self.z_coord = z_coord

    self.mark = nil
  end
end
