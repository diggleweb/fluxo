require 'test_helper'

class TransactionTemplatesControllerTest < ActionController::TestCase
  setup do
    @transaction_template = transaction_templates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:transaction_templates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create transaction_template" do
    assert_difference('TransactionTemplate.count') do
      post :create, transaction_template: { amount: @transaction_template.amount, description: @transaction_template.description, info: @transaction_template.info }
    end

    assert_redirected_to transaction_template_path(assigns(:transaction_template))
  end

  test "should show transaction_template" do
    get :show, id: @transaction_template
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @transaction_template
    assert_response :success
  end

  test "should update transaction_template" do
    patch :update, id: @transaction_template, transaction_template: { amount: @transaction_template.amount, description: @transaction_template.description, info: @transaction_template.info }
    assert_redirected_to transaction_template_path(assigns(:transaction_template))
  end

  test "should destroy transaction_template" do
    assert_difference('TransactionTemplate.count', -1) do
      delete :destroy, id: @transaction_template
    end

    assert_redirected_to transaction_templates_path
  end
end
