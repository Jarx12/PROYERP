require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:superuser)
    @product = products(:one)
  end

  test "should get index" do
    get products_url
    assert_response :success
  end

  test "should get new" do
    get new_product_url
    assert_response :success
  end

  test "should create product" do
    assert_difference("Product.count") do
      post products_url, params: { product: {
        name: "Ladrillo rojo", sku: "SKU-003",
        stock_current: 250, stock_minimum: 50
      } }
    end

    assert_redirected_to product_url(Product.order(:id).last)
    assert_equal "SKU-003", Product.order(:id).last.sku
  end

  test "should reject a duplicate sku" do
    other = products(:two)

    assert_no_difference("Product.count") do
      post products_url, params: { product: {
        name: "Duplicado", sku: other.sku, stock_current: 1, stock_minimum: 1
      } }
    end

    assert_response :unprocessable_entity
  end

  test "should show product" do
    get product_url(@product)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_url(@product)
    assert_response :success
  end

  test "should update product" do
    patch product_url(@product), params: { product: {
      name: "Cemento Portland", sku: @product.sku,
      stock_current: 400, stock_minimum: 100
    } }

    assert_redirected_to product_url(@product)
    assert_equal 400, @product.reload.stock_current
  end

  test "should destroy product" do
    assert_difference("Product.count", -1) do
      delete product_url(@product)
    end

    assert_redirected_to products_url
  end
end
