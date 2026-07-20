json.extract! vehicle, :id, :plate, :brand, :model, :status, :created_at, :updated_at
json.url vehicle_url(vehicle, format: :json)
