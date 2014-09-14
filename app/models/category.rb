class Category < ActiveRecord::Base
	has_many :transactions

	validates :name,
			  :color,
			  presence: true

	validates :name, length: { in: 3..40 }
	validates :description, length: { maximum: 500 }
	validates :color, format: { with: /\A\#([0-9a-f]{3}|[0-9a-f]{6})\Z/i, message: 'must be a valid CSS color' }
end
