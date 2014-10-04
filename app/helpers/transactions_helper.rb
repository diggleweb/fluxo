module TransactionsHelper
	def cel_amount_class(transaction)
		case transaction.transaction_type.to_sym
		when :in then 'positive'
		when :out then 'negative'
		when :transfer then 'transfer'
		when :balance then 'balance'
		end
	end

	def tip(transaction)
		description = html_escape transaction.description
		description = (' &dash; %s' % description) if description.present?

		"%s%s" % [transaction.account.name, description]
	end
end