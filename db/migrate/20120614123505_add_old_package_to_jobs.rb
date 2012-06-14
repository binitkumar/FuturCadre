class AddOldPackageToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :old_package, :boolean, :default => false
  end
end
