class AddCalendar < ActiveRecord::Migration[6.0]
  def change
    create_table :calendars do |t|
      t.integer :user_id
      t.text :access_token
      t.text :refresh_token
      t.integer :expires_in
      t.string :scope
      t.string :token_type
      t.string :email
    end
  end
end
