# Control de acceso por módulo (lectura / escritura).
#
# Cada controlador se asocia a un módulo del catálogo (ErpModule) y las
# acciones se clasifican en "lectura" o "escritura". Un superusuario siempre
# tiene acceso; el resto debe tener un permiso explícito para el módulo.
module Authorization
  extend ActiveSupport::Concern

  # Únicas acciones que se consideran de lectura.
  READ_ACTIONS = %w[ index show discarded ].freeze

  included do
    before_action :require_module_permission
    helper_method :can?, :module_visible?, :superuser?
  end

  private

  def require_module_permission
    return if current_user.blank?
    return if current_user.superuser?

    definition = ErpModule.for_controller(controller_name)
    return if definition.nil?

    level = required_permission_level
    return if current_user.can?(definition.key, level)

    deny_module_access(definition, level)
  end

  def required_permission_level
    READ_ACTIONS.include?(action_name) ? :read : :write
  end

  def deny_module_access(definition, level)
    message =
      if level == :write
        "No tienes permiso de escritura sobre el módulo #{definition.label}."
      else
        "No tienes acceso al módulo #{definition.label}."
      end

    respond_to do |format|
      format.html { redirect_to dashboard_root_path, alert: message }
      format.json { render json: { error: message }, status: :forbidden }
      format.any  { head :forbidden }
    end
  end

  # --- Utilidades para las vistas --------------------------------------

  def can?(module_key, level = :read)
    current_user&.can?(module_key, level) || false
  end

  def module_visible?(module_key)
    can?(module_key, :read)
  end

  def superuser?
    current_user&.superuser? || false
  end
end
