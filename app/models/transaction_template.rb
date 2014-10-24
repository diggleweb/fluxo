class TransactionTemplate < ActiveRecord::Base
  validates :info, :amount, presence: true
end
