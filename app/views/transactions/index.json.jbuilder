json.array!(@transactions) do |transaction|
  json.extract! transaction, :id, :category_id, :account_id, :info, :ammount_estimated, :ammount, :date_estimated, :date_transaction, :commited
  json.url transaction_url(transaction, format: :json)
end
