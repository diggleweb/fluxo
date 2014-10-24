class AddTransactionTypeToTransactionTemplate < ActiveRecord::Migration
  def change
    add_column :transaction_templates, :transaction_type, :int
  end
end
