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
end
