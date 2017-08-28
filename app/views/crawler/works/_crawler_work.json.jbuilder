json.extract! crawler_work, :id, :name, :url, :text, :company_name, :company_url, :price_scope, :address, :price_min, :price_max, :city, :company_id, :category, :website_id, :note, :send_time, :created_at, :updated_at
json.url crawler_work_url(crawler_work, format: :json)
