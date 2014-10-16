namespace :import do
  desc 'Import ofx file'
  task :ofx => :environment do |t, args|
    file = ENV["FILE"]
    throw 'FILE enviroment must be defined' if not file

    ofx = OFX file

    Transaction.transaction do
      ofx.account.transactions.map do |t|
        next unless [:debit, :credit].include? t.type

        transaction_data = {
          category_id: nil,
          account_id: 1,
          info: t.memo,
          amount_estimated: t.amount.to_f,
          amount: t.amount.to_f,
          date_estimated: t.posted_at,
          date_transaction: t.posted_at,
          commited: true,
          payee_id: '',
          description: '',
          transaction_type: (t.type == :debit ? :out : :in),
        }

        transaction = Transaction.new transaction_data
        transaction.save
      end

      # raise ActiveRecord::Rollback
    end
  end
end
