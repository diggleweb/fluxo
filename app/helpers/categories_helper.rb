module CategoriesHelper
	def category_bullet color, title = false
		title = color.name if Category == color.class
		color = color.color if Category == color.class
		"<span class=\"category-bullet\" style=\"background: #{color}\" title=\"#{title}\"></span>".html_safe
	end
end
