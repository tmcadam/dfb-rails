class CreateAuthors < ActiveRecord::Migration[5.1]
  def change
    create_table :authors do |t|
      t.string :name
      t.text :biography
      t.text :contributions

      t.timestamps
    end
  end
end
