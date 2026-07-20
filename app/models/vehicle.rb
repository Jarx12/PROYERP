class Vehicle < ApplicationRecord
  has_many :vehicle_assignments
  has_many :employees, through: :vehicle_assignments
  
  enum status: { available: 0, in_use: 1, maintenance: 2 }
  validates :plate, presence: true, uniqueness: true
end