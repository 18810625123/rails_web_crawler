json.extract! crawler_website, :id, :name, :index_url, :category, :note, :created_at, :updated_at
json.url crawler_website_url(crawler_website, format: :json)
