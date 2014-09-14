class Transaction < ActiveRecord::Base
	belongs_to :category
	belongs_to :account

	validates :info,
			  :ammount_estimated,
			  :category_id,
			  :date_estimated,
			  :commited,
			  presence: true

	validates :info, length: { maximun: 40 }

	validates :date_transaction, :amount, presence: true, if: commited?
end
