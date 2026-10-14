module AssetsHelper
  # Renders image_tag when the asset is present, otherwise a text fallback.
  # Works with Propshaft (Rails 8 default) via the asset resolver.
  def safe_image_tag(path, **options)
    return image_tag(path, **options) if asset_present?(path)

    fallback = options.delete(:fallback) || options[:alt]
    content_tag(:span, fallback.to_s, class: options[:class])
  end

  private

  def asset_present?(path)
    return false if path.blank?

    # Propshaft exposes its resolver through Rails.application.assets
    Rails.application.assets.resolver.resolve(path).present?
  rescue StandardError
    false
  end
end