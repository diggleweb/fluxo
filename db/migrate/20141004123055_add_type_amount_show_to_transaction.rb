class AddTypeAmountShowToTransaction < ActiveRecord::Migration
  def change
    change_table :transactions do |t|
      t.integer :transaction_type, :index
      t.decimal :amount_show, precision: 8, scale: 2
      t.decimal :amount_show_estimated, precision: 8, scale: 2
    end

    reversible do |dir|
      dir.up do
        Transaction.all.each do |t|
          t.transaction_type = t.amount >= 0 ? :in : :out
          t.transaction_type = :hidden if "Transferencia entre contas" === t.info
          t.save
        end
        Transaction.where('amount > 0').where(info: 'Transferencia entre contas').each do |t|
          new_transaction = Transaction.new t.as_json.except("id")
          new_transaction.transaction_type = :transfer
          new_transaction.save
        end
      end

      dir.down do
        Transaction
          .where(:transaction_type => Transaction.transaction_types[:transfer])
          .destroy_all
      end
    end
  end
end
