class AddTCategoryRefToTransactionTemplate < ActiveRecord::Migration
  def change
    add_reference :transaction_templates, :category, index: true
  end
end
