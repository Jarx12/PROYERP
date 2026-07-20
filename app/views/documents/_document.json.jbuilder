json.extract! document, :id, :title, :category, :status, :created_at, :updated_at
json.url document_url(document, format: :json)
