class TransactionTemplate < ActiveRecord::Base
  validates :info, :amount, presence: true

  def create_transaction
    params = as_json.except "id", "created_at", "updated_at"
    Transaction.new(params).tap do |transaction|
      transaction.transaction_type = :out
      transaction.amount_estimated = amount
    end
  end
end
