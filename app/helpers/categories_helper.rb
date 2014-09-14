module CategoriesHelper
	def category_bullet color
		color = color.color if Category == color.class
		"<span class=\"category-bullet\" style=\"background: #{color}\"></span>".html_safe
	end
end
