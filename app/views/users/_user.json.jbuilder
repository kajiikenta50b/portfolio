json.extract! user, :id, :username, :email, :password_digest, :faction, :rank_id, :avatar_url, :created_at, :updated_at, :created_at, :updated_at
json.url user_url(user, format: :json)
