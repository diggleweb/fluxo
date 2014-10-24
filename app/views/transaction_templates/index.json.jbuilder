json.array!(@transaction_templates) do |transaction_template|
  json.extract! transaction_template, :id, :info, :amount, :description
  json.url transaction_template_url(transaction_template, format: :json)
end
