class Discount < ApplicationRecord
  validates_presence_of :discount
  validates_numericality_of :discount, only_float: true 
  validates_presence_of :threshold
  validates_numericality_of :threshold, only_integer: true

  belongs_to :merchant 
end