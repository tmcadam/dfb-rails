class AddSlugToBiography < ActiveRecord::Migration[5.1]
  def change
    add_column :biographies, :slug, :string
  end
end
