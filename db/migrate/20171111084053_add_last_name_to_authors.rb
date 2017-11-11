class AddLastNameToAuthors < ActiveRecord::Migration[5.1]
  def change
      remove_column :authors, :name, :string
      add_column :authors, :last_name, :string
      add_column :authors, :first_name, :string
      add_index :authors, [:last_name, :first_name], unique: true
  end
end
