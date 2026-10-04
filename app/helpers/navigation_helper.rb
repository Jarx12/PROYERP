# app/helpers/navigation_helper.rb
module NavigationHelper
  # Módulos visibles en la barra de navegación del ERP, según los permisos
  # del usuario en sesión. Los módulos sin acceso no se muestran.
  def erp_nav_items
    return [] unless logged_in?

    ErpModule.all.filter_map do |definition|
      next if definition.nav_path.blank?
      next unless can?(definition.key, :read)

      {
        label: definition.label,
        icon: definition.icon,
        path: public_send(definition.nav_path),
        active: nav_item_active?(definition)
      }
    end
  end

  def nav_item_active?(definition)
    if definition.nav_path == :dashboard_root_path
      current_page?(dashboard_root_path)
    else
      definition.controllers.include?(controller_name)
    end
  end

  def back_link_for(record, fallback: nil, labels: {})
    record_url = url_for(record)

    if request.referrer&.include?(record_url)
      { path: record_url,  label: labels[:record] || "← Volver a la ficha" }
    else
      fallback_url = fallback || url_for(controller: record.class.model_name.route_key)
      { path: fallback_url, label: labels[:index]  || "← Volver al listado" }
    end
  end
end
