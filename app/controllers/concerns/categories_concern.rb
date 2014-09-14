module CategoriesConcern
  extend ActiveSupport::Concern

  included do
    def category_params
      params
        .require(:category)
        .permit :name, :color, :description
    end    
  end

end