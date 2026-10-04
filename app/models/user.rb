class User < ApplicationRecord
  has_secure_password

  belongs_to :employee, optional: true
  has_many :permissions, dependent: :destroy

  # Roles informativos del ERP. El acceso real al sistema lo define
  # `superuser` junto con los permisos por módulo.
  enum :role, { admin: 0, manager: 1, staff: 2 }, default: :staff

  normalizes :username, with: ->(value) { value.to_s.strip.downcase }
  normalizes :email,   with: ->(value) { value.to_s.strip.downcase }

  before_validation :clear_blank_email

  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       format: { with: /\A[a-z0-9._\-]+\z/i,
                                 message: "solo admite letras, números, punto, guion y guion bajo" }
  validates :email, uniqueness: { case_sensitive: false },
                   format: { with: URI::MailTo::EMAIL_REGEXP },
                   allow_blank: true
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  scope :superusers, -> { where(superuser: true) }
  scope :ordered, -> { order(Arel.sql("LOWER(username)")) }

  # Autenticación con el username o con el correo electrónico.
  def self.authenticate_by_identifier(identifier, password)
    identifier = identifier.to_s.strip.downcase
    return nil if identifier.blank?

    user = find_by(username: identifier) || find_by(email: identifier)
    user&.authenticate(password) ? user : nil
  end

  def superuser? = superuser

  # --- Autorización ---------------------------------------------------

  def can?(module_key, level = :read)
    return true if superuser?

    definition = ErpModule.find(module_key)
    return false if definition.nil?
    # El panel de inicio es la portada del ERP: siempre es accesible.
    return true if definition.key == ErpModule::DASHBOARD_KEY

    permission = permission_for(definition.key)
    return false if permission.nil?

    level.to_sym == :write ? permission.can_write? : permission.can_read?
  end

  def module_visible?(module_key) = can?(module_key, :read)
  def can_write?(module_key)      = can?(module_key, :write)

  def permission_for(module_key)
    permissions.detect { |permission| permission.module_key == module_key.to_s }
  end

  # Módulos visibles para el usuario (los de sólo lectura y los de escritura).
  def readable_modules
    permissions.filter_map { |permission| ErpModule.find(permission.module_key) }
  end

  def writable_modules
    permissions.select(&:can_write?).filter_map { |permission| ErpModule.find(permission.module_key) }
  end

  # --- Presentación ---------------------------------------------------

  def display_name
    username.presence || email
  end

  def role_label
    return "Superusuario" if superuser?

    { "admin" => "Administrador", "manager" => "Gerente", "staff" => "Personal" }.fetch(role, role.to_s.humanize)
  end

  def permissions_summary
    return "Acceso total" if superuser?
    return "Sin módulos asignados" if permissions.empty?

    readable_modules.map { |definition| definition.label }.join(", ")
  end

  # --- Permisos -------------------------------------------------------

  # Reemplaza los permisos del usuario por los indicados en el formulario.
  # Espera un hash { "modulo" => { "can_read" => ..., "can_write" => ... } }.
  def sync_module_permissions!(attributes)
    attributes = (attributes || {}).to_h.with_indifferent_access

    normalized = ErpModule.grantable.each_with_object({}) do |definition, result|
      values = attributes[definition.key]
      can_read  = ActiveModel::Type::Boolean.new.cast(values && values[:can_read]) || false
      can_write = ActiveModel::Type::Boolean.new.cast(values && values[:can_write]) || false

      result[definition.key] = { can_read: can_read || can_write, can_write: can_write }
    end

    permissions.where.not(module_key: normalized.keys).destroy_all

    normalized.each do |module_key, permission_attributes|
      permission = Permission.find_or_initialize_by(user_id: id, module_key: module_key)

      # Sólo se guardan los módulos con acceso: sin lectura no hay registro.
      if permission_attributes[:can_read]
        permission.update!(permission_attributes)
      else
        permission.destroy!
      end
    end

    permissions.reload
  end

  private

  def clear_blank_email
    self.email = nil if email.blank?
  end
end
