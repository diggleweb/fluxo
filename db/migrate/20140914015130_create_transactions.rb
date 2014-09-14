class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.belongs_to :category
      t.belongs_to :account
      
      t.string :info
      t.float :amount_estimated
      t.float :amount
      t.date :date_estimated
      t.date :date_transaction
      t.boolean :commited

      t.timestamps
    end
  end
end
