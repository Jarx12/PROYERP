json.extract! product, :id, :name, :sku, :stock_current, :stock_minimum, :created_at, :updated_at
json.url product_url(product, format: :json)
