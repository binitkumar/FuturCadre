class JobsResponsibilities < ActiveRecord::Migration
  def self.up
    create_table :jobs_responsibilities, :id => false do |t|
      t.references :job, :responsibility
    end
  end
  def self.down
    drop_table :jobs_responsibilities
  end
end
