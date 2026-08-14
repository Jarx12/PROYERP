class VehicleCategory < ApplicationRecord
  has_many :vehicles, dependent: :nullify

  validates :name, presence: true, uniqueness: true
end