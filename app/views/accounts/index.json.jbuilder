json.array!(@accounts) do |account|
  json.extract! account, :id, :name, :description
  json.url account_url(account, format: :json)
end
