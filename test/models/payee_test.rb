require 'test_helper'

class PayeeTest < ActiveSupport::TestCase
  test 'validate presence of :name' do
    payee = Payee.new
    assert payee.invalid?
    assert payee.errors.messages.has_key? :name
    payee.name = 'Anithing'
    payee.valid?
    assert_not payee.errors.messages.has_key? :name
  end
end
