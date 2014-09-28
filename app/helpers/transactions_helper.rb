module TransactionsHelper
	def tip(transaction)
		description = html_escape transaction.description
		description = (' &dash; %s' % description) if description.present?

		"%s%s" % [transaction.account.name, description]
	end
end