class CreateEventUsers < ActiveRecord::Migration
  def change
    create_table :event_users do |t|
      t.references :event_mailer, :user
      t.integer :sender_id
      t.integer :invitee_id
      t.string  :invitee_email
      t.boolean  :accepted

      t.timestamps
    end
  end
end
