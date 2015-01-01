class Board < ActiveRecord::Base
  belongs_to :game
  has_many :squares

  def initialize(size)
    # x,y,z nested arys.
    # init_columns
    # init_rows
    # init_z_groups
  end

  def render
    
  end
end
