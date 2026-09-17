# app/helpers/navigation_helper.rb
module NavigationHelper
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