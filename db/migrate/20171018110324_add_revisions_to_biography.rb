class AddRevisionsToBiography < ActiveRecord::Migration[5.1]
  def change
    add_column :biographies, :revisions, :text
  end
end
