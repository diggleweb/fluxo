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
    puts params[:category]
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

end