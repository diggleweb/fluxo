module ApplicationHelper
	def options model
		model.map { |item| [item.name, item.id] }
	end

	def error_class(field)
		field.present? && field < 0 && 'negative'
	end
end
