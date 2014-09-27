class AddPayeeRefToTransactions < ActiveRecord::Migration
  def change
    add_reference :transactions, :payee, index: true
  end
end
