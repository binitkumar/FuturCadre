class CreateInstitutes < ActiveRecord::Migration
  def change
    create_table :institutes do |t|

      t.string :slug
      t.string :name
      t.timestamps
    end

    execute("LOAD DATA LOCAL INFILE '#{Rails.root}/db/migrate/institutes.txt' INTO TABLE institutes FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES")
  end
end
