class AddSectorIdToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :sector_id, :integer
  end
end
