class CreateRecipe < ActiveRecord::Migration[5.0]
  def change
    create_table :recipes do |t|
      t.text :title
      t.integer :ready_time
      t.text :image
    end
  end
end
