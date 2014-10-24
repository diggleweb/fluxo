class TransactionTemplate < ActiveRecord::Base
  enum transaction_type: {
    :in => 0, :out => 1
  }

  belongs_to :category

  validates :info, :amount, presence: true

  def create_transaction
    params = as_json.except "id", "created_at", "updated_at"
    Transaction.new(params).tap do |transaction|
      transaction.transaction_type = :out
      transaction.amount_estimated = amount
    end
  end
end
