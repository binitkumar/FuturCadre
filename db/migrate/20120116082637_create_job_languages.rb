class CreateJobLanguages < ActiveRecord::Migration
  def change
    create_table :job_languages do |t|
      t.references :job,:language
      t.integer :level_id
      t.string :level
      t.timestamps
    end
  end
end
