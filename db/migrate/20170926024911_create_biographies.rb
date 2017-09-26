class CreateBiographies < ActiveRecord::Migration[5.1]
  def change
    create_table :biographies do |t|
      t.string :title
      t.string :lifespan
      t.text :body
      t.string :authors

      t.timestamps
    end
  end
end
