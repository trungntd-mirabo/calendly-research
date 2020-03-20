class AddZoomConnection < ActiveRecord::Migration[6.0]
  def change
    create_table :zoom_connections do |t|
      t.integer :user_id
      t.text :access_token
      t.text :refresh_token
      t.integer :expires_in
      t.text :scope
      t.string :token_type
      t.string :zoom_id
      t.string :email
    end
  end
end
