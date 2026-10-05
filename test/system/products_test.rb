require "application_system_test_case"

class ProductsTest < ApplicationSystemTestCase
  setup do
    sign_in_as users(:superuser)
    @product = products(:one)
  end

  test "visiting the index" do
    visit products_url

    assert_selector "h1", text: "Inventario de Productos"
  end

  test "should create product" do
    visit new_product_url

    fill_in "product_name", with: "Ladrillo rojo"
    fill_in "product_sku", with: "SKU-777"
    fill_in "product_stock_current", with: "120"
    fill_in "product_stock_minimum", with: "20"
    click_on "Guardar Producto"

    assert_text "El producto fue creado con éxito."
    assert_equal "SKU-777", Product.order(:id).last.sku
  end

  test "should update Product" do
    visit edit_product_url(@product)

    fill_in "product_stock_current", with: "500"
    click_on "Guardar Producto"

    assert_text "El producto fue actualizado con éxito."
    assert_equal 500, @product.reload.stock_current
  end
end
