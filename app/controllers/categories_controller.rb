class CategoriesController < ApplicationController
  include CategoriesConcern

  # GET /categories
  def index
    @categories = Category.all

    respond_to do |format|
      format.html  # index.html.erb
      format.json  { render :json => @categories }
    end
  end

  # GET /categories/new
  def new
    @category = Category.new

    respond_to do |format|
      format.html  # new.html.erb
      format.json  { render :json => @category }
    end
  end

  # POST /categories
  def create
    @category = Category.new category_params

    respond_to do |format|
      if @category.save
        format.html  { redirect_to(@category, :notice => 'category was successfully created.') }
        format.json  { render :json => @category, :status => :created, :location => @category }
      else
        format.html  { render :action => "new" }
        format.json  { render :json => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /categories/:id
  def show
    @category = Category.find params[:id]
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :jsonn => @category }
    end
  end

  # GET /categories/:id/edit
  def edit
    @category = Category.find params[:id]
    respond_to do |format|
      format.html # edit.html.erb
      format.json { render :jsonn => @category }
    end
  end

  # PATH/PUT /categories/:id
  def update
    @category = Category.find params[:id]
    
    respond_to do |format|
      if @category.update category_params
        format.html  { redirect_to(@category, :notice => 'category was successfully updated.') }
        format.json  { render :json => @category, :status => :created, :location => @category }
      else
        format.html  { render :action => "edit" }
        format.json  { render :json => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/:id
  def destroy
    @category = Category.find params[:id]
    @category.destroy

    respond_to do |format|
      format.html  { redirect_to categories_path, notice: 'categoria apagada!' }
      format.json  { render :nothing }
    end
  end

end