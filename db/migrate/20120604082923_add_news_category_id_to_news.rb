class AddNewsCategoryIdToNews < ActiveRecord::Migration
  def change
    add_column :news, :news_category_id, :integer
  end
end
