class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images do |t|
      t.string :title
      t.text :caption
      t.string :attribution
      t.references :biography, foreign_key: true

      t.timestamps
    end
  end
end
