json.extract! crawler_menu, :id, :name, :namespace, :controller, :action, :note, :parent_id, :created_at, :updated_at
json.url crawler_menu_url(crawler_menu, format: :json)
