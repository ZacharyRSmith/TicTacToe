class Square < ActiveRecord::Base
  belongs_to :board

#     after_initialize do 
#    self[:measurement] = "US" 
#    self[:bmr_formula] = "katch"
#    self[:fat_factor] = 0.655
#    self[:protein_factor] = 1.25
#    puts "User has been initialized!"
# end
    
#   def initialize(coords = {})
#     self.x_coord = coords[:x_coord]
#     self.y_coord = coords[:y_coord]
#     self.z_coord = coords[:z_coord]

#     self.mark = nil
#   end
end
