# Catálogo de módulos del ERP sujetos a permisos.
#
# Cada módulo agrupa uno o varios controladores y expone la información que
# necesita la interfaz (etiqueta, ícono y ruta de navegación). Los módulos
# marcados como "grantable" son los que se muestran con casillas en el panel
# de usuarios; el resto sólo lo puede administrar un superusuario.
class ErpModule
  Definition = Struct.new(:key, :label, :icon, :controllers, :nav_path, :grantable, keyword_init: true) do
    def grantable?      = grantable
    def superuser_only? = !grantable
  end

  DASHBOARD_KEY = "dashboard"

  DEFINITIONS = [
    Definition.new(key: DASHBOARD_KEY, label: "Inicio", icon: "🏠",
                   controllers: %w[ dashboard ], nav_path: :dashboard_root_path, grantable: false),

    Definition.new(key: "inventory", label: "Inventario", icon: "📦",
                   controllers: %w[ products ], nav_path: :products_path, grantable: true),

    Definition.new(key: "hr", label: "Empleados", icon: "👨‍💼",
                   controllers: %w[ employees ], nav_path: :employees_path, grantable: true),

    Definition.new(key: "documents", label: "Documentos", icon: "📁",
                   controllers: %w[ documents ], nav_path: :documents_path, grantable: true),

    Definition.new(key: "finance", label: "Finanzas", icon: "📊",
                   controllers: %w[ financial_transactions ], nav_path: :financial_transactions_path, grantable: true),

    Definition.new(key: "fleet", label: "Vehículos", icon: "🚗",
                   controllers: %w[ vehicles ], nav_path: :vehicles_path, grantable: true),

    Definition.new(key: "settings", label: "Configuración", icon: "⚙️",
                   controllers: %w[ settings positions categories warehouses vehicle_categories
                                    transaction_categories bank_accounts projects ],
                   nav_path: :settings_path, grantable: true),

    Definition.new(key: "users", label: "Usuarios", icon: "🔐",
                   controllers: %w[ users ], nav_path: :users_path, grantable: false)
  ].freeze

  class << self
    def all           = DEFINITIONS
    def grantable     = DEFINITIONS.select(&:grantable?)
    def keys          = DEFINITIONS.map(&:key)
    def grantable_keys = grantable.map(&:key)

    def find(key)
      DEFINITIONS.find { |definition| definition.key == key.to_s }
    end

    def exists?(key) = find(key).present?

    # Módulo al que pertenece un controlador (nil si no está protegido).
    def for_controller(controller_name)
      DEFINITIONS.find { |definition| definition.controllers.include?(controller_name.to_s) }
    end
  end
end
