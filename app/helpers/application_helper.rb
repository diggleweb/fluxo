module ApplicationHelper
	def options model
		model.map { |item| [item.name, item.id] }
	end
end
