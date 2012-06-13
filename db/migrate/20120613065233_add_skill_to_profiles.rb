class AddSkillToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :skill, :string
  end
end
