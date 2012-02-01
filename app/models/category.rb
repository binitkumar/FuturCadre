class Category < ActiveRecord::Base
  has_many :children, :class_name => "Category", :foreign_key => 'parent_id'
  belongs_to :parent, :class_name => "Category"
  has_many :jobs
  has_many :theses

  def self.main_categories
    where("parent_id IS NULL")
  end

  Category_Type = { 1 => 'job',
                    2 => 'group' }


end
