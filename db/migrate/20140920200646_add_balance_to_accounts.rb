class AddBalanceToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :balance, :decimal, precision: 8, scale: 2
    add_column :accounts, :balance_estimated, :decimal, precision: 8, scale: 2
  end
end
