class JobsResponsibilities < ActiveRecord::Migration
  def change
    create_table :jobs_responsibilities, :id => false do |t|
      t.references :job, :responsibility
    end
    end
end
