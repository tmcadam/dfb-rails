class AddUniqueConstraintsToBiographyAuthor < ActiveRecord::Migration[5.1]
  def change
      add_index :biography_authors, [:biography_id, :author_id], unique: true
      add_index :biography_authors, [:biography_id, :author_position], unique: true
  end
end
