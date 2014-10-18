# encoding: utf-8

class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  before_action :set_associations, only: [:new, :edit, :create, :update]

  # GET /transactions
  # GET /transactions.json
  def index
    types = Transaction.transaction_types
    where_types = { transaction_type: [ types[:in], types[:out], types[:balance], types[:transfer] ] }
    @transactions = Transaction.where(where_types).order('date_estimated DESC, id DESC').paginate(:page => params[:page])
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new transaction_type: Transaction.transaction_types[:in]
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions
  # POST /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to transactions_url, notice: 'Transaction was successfully created.' }
        format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to transactions_url, notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transactions_url, notice: 'Transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /transactions/new/transfer
  def new_transfer
    @transaction = Transaction.new
    @categories = Category.all
    @accounts = Account.all
    @payees = Payee.all
  end

  # POST /transactions/new/transfer
  def create_transfer
    types = Transaction.transaction_types
    from_account = Account.find(transfer_params[:account_id].first)
    to_account = Account.find(transfer_params[:account_id].last)

    transfer_params[:account_id].each_with_index do |account_id, index|
      info = 'Transferencia entre contas'
      description = 'Transferencia entre contas: %s → %s' % [from_account.name, to_account.name]
      amount = transfer_params[:amount]
      amount_estimated = transfer_params[:amount_estimated]
      if index == 0
        amount = -1 * (amount)
        amount_estimated = -1 * (amount_estimated)
      end
      transaction_attributes = transfer_params.merge(
        account_id: account_id,
        transaction_type: types[:hidden],
        info: info,
        description: description,
        amount: amount,
        amount_estimated: amount_estimated,
      )
      transaction = Transaction.new transaction_attributes
      transaction.save
    end

    transaction = Transaction.last
    transaction_showed = Transaction.new transaction.as_json.except("id")
    transaction_showed.transaction_type = types[:transfer]
    transaction_showed.amount = transfer_params[:amount]
    transaction_showed.amount_estimated = transfer_params[:amount_estimated]
    transaction_showed.save

    respond_to do |format|
      format.html { redirect_to transactions_url, notice: 'Transaction was successfully created.' }
      format.json { render :show, status: :created, location: @transaction }
    end    
  end

  private
    def set_associations
      @accounts = Account.all.order :name
      @categories = Category.all.order :name
      @payees = Payee.all.order :name
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_params
      params
        .require(:transaction)
        .permit(
          :category_id, :account_id, :info, :amount_estimated,
          :amount, :date_estimated, :date_transaction, :commited, :payee_id,
          :description, :transaction_type
        )
        .tap do |p|
          p[:transaction_type] = Transaction.transaction_types.invert[p[:transaction_type].to_i] if p[:transaction_type]
        end
    end

    def transfer_params
      transfer ||= params
        .require(:transaction)
        .permit(:amount_estimated, :amount, :date_estimated, :date_transaction, :commited, :account_id => [:account_id])
        .tap do |t|
          t[:account_id] = t[:account_id].map { |k, v| v[:account_id] }
          t[:amount] = t[:amount].to_f
          t[:amount_estimated] = t[:amount_estimated].to_f
        end
    end
end
