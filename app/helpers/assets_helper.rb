module AssetsHelper
  # Renders image_tag when the asset is present, otherwise a text fallback.
  # Lets CI and fresh clones boot without image files that get synced out-of-band.
  def safe_image_tag(path, **options)
    return image_tag(path, **options) if asset_present?(path)

    fallback = options.delete(:fallback) || options[:alt]
    content_tag(:span, fallback.to_s, class: options[:class])
  end

  private

  def asset_present?(path)
    return false if path.blank?

    Rails.application.assets.find_asset(path).present?
  rescue StandardError
    false
  end
end
