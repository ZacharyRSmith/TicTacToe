class Square < ActiveRecord::Base
  belongs_to :board
  has_and_belongs_to_many :lines

  def get_coords_str
    coords_str = self.x_coord.to_s + "-" +
                 self.y_coord.to_s + "-" +
                 self.z_coord.to_s
  end
end
