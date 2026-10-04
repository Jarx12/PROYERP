class Document < ApplicationRecord
    belongs_to :employee, optional: true
    has_one_attached :file
    enum :category, { contract: 0, invoice: 1, legal: 2, manual: 3 }, default: :contract
    enum :status, { draft: 0, active: 1, archived: 2 }, default: :draft

    # Validaciones
    validates :title, :category, :status, presence: true
    validates :file, presence: true # Hace obligatorio subir el archivo adjunto
end
