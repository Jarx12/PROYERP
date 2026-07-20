class Employee < ApplicationRecord
  # Relaciones con los otros módulos
  has_many :vehicle_assignments 
  has_many :vehicles, through: :vehicle_assignments 
  has_many :payslips
  has_many :documents, dependent: :destroy

  # Validaciones Obligatorias (*)
  validates :name, :surname, :cedula, :birthday, presence: true
  
  # Validaciones adicionales recomendadas
  validates :cedula, uniqueness: true, numericality: { only_integer: true }
end