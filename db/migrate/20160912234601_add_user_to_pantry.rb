class AddUserToPantry < ActiveRecord::Migration[5.0]
  def change
    add_reference :pantries, :user, foreign_key: true
  end
end
