require 'test_helper'

class TransactionsControllerTest < ActionController::TestCase
  setup do
    @transaction = transactions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:transactions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create transaction" do
    assert_difference('Transaction.count') do
      post :create, transaction: { account_id: @transaction.account_id, ammount: @transaction.ammount, ammount_estimated: @transaction.ammount_estimated, category_id: @transaction.category_id, commited: @transaction.commited, date_estimated: @transaction.date_estimated, date_transaction: @transaction.date_transaction, info: @transaction.info }
    end

    assert_redirected_to transaction_path(assigns(:transaction))
  end

  test "should show transaction" do
    get :show, id: @transaction
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @transaction
    assert_response :success
  end

  test "should update transaction" do
    patch :update, id: @transaction, transaction: { account_id: @transaction.account_id, ammount: @transaction.ammount, ammount_estimated: @transaction.ammount_estimated, category_id: @transaction.category_id, commited: @transaction.commited, date_estimated: @transaction.date_estimated, date_transaction: @transaction.date_transaction, info: @transaction.info }
    assert_redirected_to transaction_path(assigns(:transaction))
  end

  test "should destroy transaction" do
    assert_difference('Transaction.count', -1) do
      delete :destroy, id: @transaction
    end

    assert_redirected_to transactions_path
  end
end
