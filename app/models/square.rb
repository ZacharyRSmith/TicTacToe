class Square < ActiveRecord::Base
  belongs_to :board
  attr_accessor :mark

  def initialize()
    
  end
end
