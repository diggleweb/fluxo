class Account < ActiveRecord::Base
	validates :name, presence: true
	validates :description, length: { maximum: 500 }
end
