class Permission < ApplicationRecord
  belongs_to :user

  validates :module_key, presence: true,
                       inclusion: { in: ->(_) { ErpModule.keys } },
                       uniqueness: { scope: :user_id }

  scope :readable, -> { where(can_read: true) }
  scope :writable, -> { where(can_write: true) }

  before_validation :grant_read_when_write_granted

  def erp_module
    ErpModule.find(module_key)
  end

  def module_label
    erp_module&.label.to_s
  end

  def module_icon
    erp_module&.icon.to_s
  end

  private

  # Escribir siempre implica leer: evita matrices de permisos inconsistentes.
  def grant_read_when_write_granted
    self.can_read = true if can_write?
  end
end
