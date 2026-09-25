class Project < ApplicationRecord
  has_one_attached :cover_image

  validates :name, presence: true
end
