class AddAvailSearchToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avail_search, :integer
  end
end
