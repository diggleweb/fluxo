class Account < ActiveRecord::Base
	validates :name, presence: true
	validates :description, length: { maximum: 500 }

	before_save :update_balance

	protected

		def update_balance
			self.balance = Transaction.where(account: self.id).sum :amount
			self.balance_estimated = Transaction.where(account: self.id).sum :amount_estimated
		end
end
