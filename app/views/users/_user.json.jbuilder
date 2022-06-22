json.extract! user, :id, :name, :web_url, :title, :description, :is_active, :is_deleted, :friends_count, :created_at, :updated_at
json.url user_url(user, format: :json)
