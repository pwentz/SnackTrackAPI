class AddGoogleIdToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :google_id, :text
  end
end
