class Vehicle < ApplicationRecord
  # Relaciones
  belongs_to :vehicle_category, optional: true
  has_many :vehicle_assignments, dependent: :destroy
  has_many :employees, through: :vehicle_assignments

  # Archivos Adjuntos (Active Storage)
  has_one_attached :registration_title
  has_one_attached :rcv_policy
  has_one_attached :owner_dni_file

  # Enums (Sintaxis para Rails 7.1 / Rails 8)
  enum :status, { available: 0, in_use: 1, maintenance: 2 }, default: :available
  enum :condition, { own: 0, rented: 1 }, default: :own

  # Validaciones obligatorias mínimas
  validates :plate, presence: true, uniqueness: true
  validates :brand, :model, presence: true
end
