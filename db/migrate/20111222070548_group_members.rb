class GroupMembers < ActiveRecord::Migration
   def change
    create_table :group_members, :id => false do |t|
      t.references :group, :user, :as=> :member
    end
    end

end
