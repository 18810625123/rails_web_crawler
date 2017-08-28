json.extract! crawler_plan, :id, :website_id, :source, :name, :url, :page, :note, :created_at, :updated_at
json.url crawler_plan_url(crawler_plan, format: :json)
