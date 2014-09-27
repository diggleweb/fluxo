class Transaction < ActiveRecord::Base
    belongs_to :category
    belongs_to :account
    belongs_to :payee

    validates :info,
              :amount_estimated,
              :date_estimated,
              presence: true

    validates :commited,  inclusion: { in: [false, true] }, allow_nil: false

    validates :info, length: { maximum: 40 }

    validates :date_transaction, :amount, presence: true, if: "true == commited"

    after_save :update_account

    protected

      def update_account
        self.account.save
      end
end
