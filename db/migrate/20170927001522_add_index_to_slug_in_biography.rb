class AddIndexToSlugInBiography < ActiveRecord::Migration[5.1]
  def change
      add_index :biographies, :slug
  end
end
