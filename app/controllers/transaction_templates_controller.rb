class TransactionTemplatesController < ApplicationController
  before_action :set_transaction_template, only: [:show, :edit, :update, :destroy]

  # GET /transaction_templates
  # GET /transaction_templates.json
  def index
    @transaction_templates = TransactionTemplate.all
  end

  # GET /transaction_templates/1
  # GET /transaction_templates/1.json
  def show
  end

  # GET /transaction_templates/new
  def new
    @transaction_template = TransactionTemplate.new
  end

  # GET /transaction_templates/1/edit
  def edit
  end

  # POST /transaction_templates
  # POST /transaction_templates.json
  def create
    @transaction_template = TransactionTemplate.new(transaction_template_params)

    respond_to do |format|
      if @transaction_template.save
        format.html { redirect_to transaction_templates_url, notice: 'Transaction template was successfully created.' }
        format.json { render :show, status: :created, location: @transaction_template }
      else
        format.html { render :new }
        format.json { render json: @transaction_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transaction_templates/1
  # PATCH/PUT /transaction_templates/1.json
  def update
    respond_to do |format|
      if @transaction_template.update(transaction_template_params)
        format.html { redirect_to transaction_templates_url, notice: 'Transaction template was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction_template }
      else
        format.html { render :edit }
        format.json { render json: @transaction_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transaction_templates/1
  # DELETE /transaction_templates/1.json
  def destroy
    @transaction_template.destroy
    respond_to do |format|
      format.html { redirect_to transaction_templates_url, notice: 'Transaction template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction_template
      @transaction_template = TransactionTemplate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_template_params
      params.require(:transaction_template).permit(:info, :amount, :description)
    end
end
