class Employee < ApplicationRecord
  include Discard::Model
  # Relaciones con los otros módulos
  has_many :vehicle_assignments 
  has_many :vehicles, through: :vehicle_assignments 
  has_many :payslips
  has_many :documents, dependent: :destroy
  belongs_to :position, optional: true
  has_one :user, dependent: :destroy
  # Validaciones Obligatorias (*)
  validates :name, :surname, :cedula, :birthday, presence: true
  
  # Validaciones adicionales recomendadas
  validates :cedula, uniqueness: true, numericality: { only_integer: true }

  
  # Métodos auxiliares para la vista
  def full_name
    "#{name} #{surname}".strip
  end

  def full_name_complete
    "#{name} #{name2} #{surname} #{surname2}".squish
  end

  def full_name_with_cedula
    "#{full_name} (C.I: #{cedula})"
  end

end