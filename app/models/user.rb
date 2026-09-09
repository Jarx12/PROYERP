class User < ApplicationRecord
  has_secure_password

  belongs_to :employee, optional: true

  # Roles de acceso al ERP
  enum :role, { admin: 0, manager: 1, staff: 2 }, default: :staff

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
end