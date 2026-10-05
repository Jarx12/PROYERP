require "test_helper"

# Los assets referenciados por las vistas deben estar versionados: si un archivo
# se pierde (o queda sin añadir a git), Propshaft lanza MissingAssetError y las
# pruebas de páginas fallan en CI aunque pasen en el entorno local.
class AssetIntegrityTest < ActiveSupport::TestCase
  ASSET_DIRECTORY = Rails.root.join("app/assets/images").freeze

  test "las imágenes referenciadas por las vistas existen en el repositorio" do
    referenced = Dir[Rails.root.join("app/views/**/*.erb")]
      .flat_map { |view| File.read(view).scan(/(?:image_tag|image_path)\s+["']([^"']+)["']/).flatten }
      .reject(&:empty?)
      .uniq
      .sort

    assert_not_empty referenced, "se esperaban imágenes referenciadas en las vistas"

    missing = referenced.reject { |asset| ASSET_DIRECTORY.join(asset).exist? }

    assert_empty missing, "imágenes ausentes en app/assets/images: #{missing.join(', ')}"
  end

  test "ningún asset está excluido por .gitignore" do
    ignored = `git check-ignore #{ASSET_DIRECTORY}/* 2>/dev/null`.split("\n")

    assert_empty ignored, "assets ignorados por git y ausentes en CI: #{ignored.join(', ')}"
  end
end
