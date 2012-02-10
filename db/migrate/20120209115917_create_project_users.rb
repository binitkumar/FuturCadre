class CreateProjectUsers < ActiveRecord::Migration
  def change
    create_table :project_users do |t|
      t.references :user, :project
      t.string :invitee_email
      t.boolean :invite
      t.boolean :request
      t.string :token
      t.datetime :sent_at
      t.boolean :is_user
      t.integer :sender_id
       t.timestamps
    end
  end
end
