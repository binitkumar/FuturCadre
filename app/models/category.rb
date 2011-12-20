class Category < ActiveRecord::Base
	has_many :children, :class_name => "Category", :foreign_key => 'parent_id'
  belongs_to :parent, :class_name => "Category"
  has_many :groups

	def self.main_categories
		where("parent_id IS NULL")
	end

end
