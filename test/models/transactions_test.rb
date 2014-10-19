require 'test_helper'

class TransactionsTest < ActiveSupport::TestCase
  test 'transaction types' do
    transaction_types = Transaction.transaction_types

    assert transaction_types.has_key? :in
    assert transaction_types.has_key? :out
    assert transaction_types.has_key? :balance
    assert transaction_types.has_key? :transfer
    assert transaction_types.has_key? :hidden
    assert transaction_types.has_key? :fake_in
    assert transaction_types.has_key? :fake_out
  end

  test 'transaction belongs to category' do
    transaction = Transaction.new

    assert transaction.respond_to? :category
    assert transaction.respond_to? :category=
    assert transaction.respond_to? :build_category
    assert transaction.respond_to? :create_category

    category = transaction.build_category
    assert Category == category.class
  end

  test 'transaction belongs to account' do
    transaction = Transaction.new
    
    assert transaction.respond_to? :account
    assert transaction.respond_to? :account=
    assert transaction.respond_to? :build_account
    assert transaction.respond_to? :create_account

    account = transaction.build_account
    assert Account == account.class
  end

  test 'transaction belongs to payee' do
    transaction = Transaction.new
    
    assert transaction.respond_to? :payee
    assert transaction.respond_to? :payee=
    assert transaction.respond_to? :build_payee
    assert transaction.respond_to? :create_payee

    payee = transaction.build_payee
    assert Payee == payee.class
  end

  test 'transaction must have :info, :account, :transaction_type, :amount_estimated, :date_estimated' do
    transaction = Transaction.new
    assert transaction.invalid?
    assert transaction.errors.messages.has_key? :info
    assert transaction.errors.messages.has_key? :account
    assert transaction.errors.messages.has_key? :transaction_type
    assert transaction.errors.messages.has_key? :amount_estimated
    assert transaction.errors.messages.has_key? :date_estimated

    transaction.info = 'Anything'
    transaction.build_account
    transaction.transaction_type = Transaction.transaction_types[:in]
    transaction.amount_estimated = 10
    transaction.date_estimated = Date.today

    transaction.valid?

    assert_not transaction.errors.messages.has_key? :info
    assert_not transaction.errors.messages.has_key? :account
    assert_not transaction.errors.messages.has_key? :transaction_type
    assert_not transaction.errors.messages.has_key? :amount_estimated
    assert_not transaction.errors.messages.has_key? :date_estimated
  end

  test ':commited must be true or false (nil)' do
    transaction = Transaction.new
    assert transaction.invalid?
    assert transaction.errors.messages.has_key? :commited

    transaction.commited = false
    assert transaction.commited == false

    transaction.commited = 'false'
    assert transaction.commited == false

    transaction.commited = 'off'
    assert transaction.commited == false

    transaction.commited = 'string'
    assert transaction.commited == false

    transaction.commited = Object.new
    assert transaction.commited == false

    transaction.commited = Hash.new
    assert transaction.commited == false

    transaction.commited = :symbol
    assert transaction.commited == false

    transaction.commited = :true
    assert transaction.commited == false

    transaction.commited = true
    assert transaction.commited == true

    transaction.commited = 'true'
    assert transaction.commited == true

    transaction.commited = 'on'
    assert transaction.commited == true

    transaction.commited = true
    transaction.valid?
    assert_not transaction.errors.messages.has_key? :commited

    transaction.commited = false
    transaction.valid?
    assert_not transaction.errors.messages.has_key? :commited
  end

  test ':info must have only 40 chars' do
    transaction = Transaction.new info: ('x' * 40)
    transaction.valid?
    assert_not transaction.errors.messages.has_key? :info

    transaction = Transaction.new info: ('x' * 41)
    assert transaction.invalid?
    assert transaction.errors.messages.has_key? :info
  end

  test 'must have :date_transaction, :amount when :commited == true' do
    transaction = Transaction.new
    transaction.valid?

    assert_not transaction.errors.messages.has_key? :date_transaction
    assert_not transaction.errors.messages.has_key? :amont

    transaction = Transaction.new commited: false
    transaction.valid?

    assert_not transaction.errors.messages.has_key? :date_transaction
    assert_not transaction.errors.messages.has_key? :amont

    transaction = Transaction.new commited: true
    transaction.valid?
    assert transaction.errors.messages.has_key? :date_transaction
    assert transaction.errors.messages.has_key? :amount
  end

  test 'scope :alowed_for_sum only :in, :out, :hidden types' do
    query_transactions = [
      Transaction.transaction_types[:in],
      Transaction.transaction_types[:out],
      Transaction.transaction_types[:hidden],
    ]
    assert Transaction.alowed_for_sum.where_values_hash == {"transaction_type"=> query_transactions} 
  end

  test 'update account when save transaction' do
    account = Account.take

    old_balance = account.balance
    old_balance_estimated = account.balance_estimated

    attrs = {
      info: 'Anything',
      transaction_type: Transaction.transaction_types[:in],
      account: account,
      amount_estimated: 100,
      date_estimated: Date.today,
      commited: true,
      amount: 200,
      date_transaction: Date.today,
    }
    transaction = Transaction.create attrs

    assert transaction.save
    account.reload

    assert old_balance + 200 == account.balance
    assert old_balance_estimated + 100 == account.balance_estimated
  end

  test 'trigger correct values before validate transaction' do
    transaction_types = Transaction.transaction_types
    transaction = Transaction.new transaction_type: transaction_types[:in], amount: 100
    transaction.valid?
    assert transaction.amount == 100

    transaction = Transaction.new transaction_type: transaction_types[:in], amount: -100
    transaction.valid?
    assert transaction.amount == 100

    transaction = Transaction.new transaction_type: transaction_types[:out], amount: 500
    transaction.valid?
    assert transaction.amount == -500

    transaction = Transaction.new transaction_type: transaction_types[:out], amount: -500
    transaction.valid?
    assert transaction.amount == -500

    transaction = Transaction.new transaction_type: transaction_types[:transfer], amount: 350
    transaction.valid?
    assert transaction.amount == 0
    assert transaction.amount_show == 350

    transaction = Transaction.new transaction_type: transaction_types[:transfer], amount: -350
    transaction.valid?
    assert transaction.amount == 0
    assert transaction.amount_show == 350
  end

  test 'show_amount always respond with integer' do
    transaction_types = Transaction.transaction_types

    transaction = Transaction.new transaction_type: transaction_types[:in], amount: nil
    assert 0 == transaction.show_amount

    transaction = Transaction.new transaction_type: transaction_types[:in], amount: 100
    assert 100 == transaction.show_amount

    transaction = Transaction.new transaction_type: transaction_types[:out], amount: nil
    assert 0 == transaction.show_amount

    transaction = Transaction.new transaction_type: transaction_types[:out], amount: 100
    assert 100 == transaction.show_amount

    transaction = Transaction.new transaction_type: transaction_types[:balance], amount: nil
    assert 0 == transaction.show_amount

    transaction = Transaction.new transaction_type: transaction_types[:balance], amount: 100
    assert 100 == transaction.show_amount

    transaction = Transaction.new transaction_type: transaction_types[:transfer], amount: nil, amount_show: 500
    assert 500 == transaction.show_amount

    transaction = Transaction.new transaction_type: transaction_types[:transfer], amount: 100, amount_show: 500
    assert 500 == transaction.show_amount
  end

  test 'show_amount_estimated always respond with integer' do
    transaction_types = Transaction.transaction_types

    transaction = Transaction.new transaction_type: transaction_types[:in], amount_estimated: nil
    assert 0 == transaction.show_amount_estimated

    transaction = Transaction.new transaction_type: transaction_types[:in], amount_estimated: 100
    assert 100 == transaction.show_amount_estimated

    transaction = Transaction.new transaction_type: transaction_types[:out], amount_estimated: nil
    assert 0 == transaction.show_amount_estimated

    transaction = Transaction.new transaction_type: transaction_types[:out], amount_estimated: 100
    assert 100 == transaction.show_amount_estimated

    transaction = Transaction.new transaction_type: transaction_types[:balance], amount_estimated: nil
    assert 0 == transaction.show_amount_estimated

    transaction = Transaction.new transaction_type: transaction_types[:balance], amount_estimated: 100
    assert 100 == transaction.show_amount_estimated

    transaction = Transaction.new transaction_type: transaction_types[:transfer], amount_estimated: nil, amount_show_estimated: 500
    assert 500 == transaction.show_amount_estimated

    transaction = Transaction.new transaction_type: transaction_types[:transfer], amount_estimated: 100, amount_show_estimated: 500
    assert 500 == transaction.show_amount_estimated
  end
end
