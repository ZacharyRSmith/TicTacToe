class Line < ActiveRecord::Base
  has_and_belongs_to_many :squares
  belongs_to :board
end
