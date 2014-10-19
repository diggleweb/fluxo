require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test 'category have transactions' do
    category = Category.new

    assert category.respond_to? :transactions
    assert category.respond_to? :transactions=
    assert category.respond_to? :add_to_transaction
  end

  test 'validate :name, :color presence' do
    category = Category.new
    assert category.invalid?

    assert category.errors.messages.has_key? :name
    assert category.errors.messages.has_key? :color

    category.name = 'Anything'
    category.color = '#FFFFFF'
    category.valid?

    assert_not category.errors.messages.has_key? :name
    assert_not category.errors.messages.has_key? :color
  end

  test ':name must have 3...40 chars' do
    category = Category.new name: 'xx'
    assert category.invalid?
    assert category.errors.messages.has_key? :name

    category = Category.new name: 'xxx'
    category.valid?
    assert_not category.errors.messages.has_key? :name

    category = Category.new name: ('x' * 40)
    category.valid?
    assert_not category.errors.messages.has_key? :name

    category = Category.new name: ('x' * 41)
    assert category.invalid?
    assert category.errors.messages.has_key? :name
  end

  test ':description only can have 500 chars (includes nil)' do
    category = Category.new description: nil
    category.valid?
    assert_not category.errors.messages.has_key? :description

    category = Category.new description: 'x'
    category.valid?
    assert_not category.errors.messages.has_key? :description

    category = Category.new description: ('x' * 500)
    category.valid?
    assert_not category.errors.messages.has_key? :description

    category = Category.new description: ('x' * 501)
    category.valid?
    assert category.errors.messages.has_key? :description
  end

  test 'color must be CSS color' do
    valid_values = ['#FFF', '#FFFFFF', '#000', '#000000', '#F0F0F0', '#19d01cc']
    invalid_values = ['a', 'FFFFFF', '0', '000000', '#AA', '#FFGG33']

    valid_values.each do |valid_value|
      category = Category.new color: valid_value
      category.valid?
      puts valid_value
      assert_not category.errors.messages.has_key? :color
    end

    invalid_values.each do |invalid_value|
      category = Category.new color: invalid_value
      category.valid?
      assert_not category.errors.messages.has_key? :color
    end

  end
end
