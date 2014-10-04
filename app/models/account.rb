class Account < ActiveRecord::Base
	attr_accessor :start_ammount

	validates :name, presence: true
	validates :description, length: { maximum: 500 }

	before_save :update_balance
	after_create :create_transaction_from_start_ammount

	protected

		def update_balance
			self.balance = Transaction.alowed_for_sum.where(account: self.id).sum :amount
			self.balance_estimated = Transaction.alowed_for_sum.where(account: self.id).sum :amount_estimated
		end

		def create_transaction_from_start_ammount
			return unless @start_ammount.present?

			transaction = Transaction.new({
				:category_id => nil,
				:account_id => self.id,
				:info => "Adicionando conta \"#{self.name}\"",
				:amount_estimated => @start_ammount,
				:amount => @start_ammount,
				:date_estimated => DateTime.now,
				:date_transaction => DateTime.now,
				:commited => true
			})
			transaction.save
		end
end
