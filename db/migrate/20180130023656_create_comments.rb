class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.references :biography, foreign_key: true
      t.string :name
      t.string :email
      t.text :comment
      t.boolean :approved
      t.timestamps
    end
  end
end
