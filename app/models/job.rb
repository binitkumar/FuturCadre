class Job < ActiveRecord::Base
	belongs_to :employer, :polymorphic => true
	belongs_to :country
	belongs_to :region
	belongs_to :city

	searchable do
		string :name
		string :description
		integer :country_id
		integer :region_id
		integer :city_id
		integer :category_id
#		text :comments do
#			comments.map(&:content)
#		end
#		time :published_at
#		string :publish_month
	end

end
