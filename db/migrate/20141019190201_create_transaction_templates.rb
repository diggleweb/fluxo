class CreateTransactionTemplates < ActiveRecord::Migration
  def change
    create_table :transaction_templates do |t|
      t.string :info
      t.decimal :amount
      t.text :description

      t.timestamps
    end
  end
end
