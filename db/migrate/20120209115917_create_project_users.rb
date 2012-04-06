class CreateProjectUsers < ActiveRecord::Migration
  def self.up
    create_table :project_users do |t|
      t.references :user, :project
      #t.string :invitee_email
      t.boolean :is_approved , :default => false
      #t.boolean :request
      #t.string :token
      #t.datetime :sent_at
      #t.boolean :is_user
      #t.integer :sender_id
       t.timestamps
    end
  end
  def self.down
    drop_table :project_users
  end
end
