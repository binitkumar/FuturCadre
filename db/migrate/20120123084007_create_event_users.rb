class CreateEventUsers < ActiveRecord::Migration
  def self.up
    create_table :event_users do |t|
      t.references :event_mailer, :user
      t.integer :sender_id
      t.integer :invitee_id
      t.string  :invitee_email
      t.boolean  :accepted

      t.timestamps
    end
  end
  def self.down
    drop_table :event_users
  end
end
