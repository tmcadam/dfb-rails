class AddExternalLinksToBiography < ActiveRecord::Migration[5.1]
  def change
    add_column :biographies, :external_links, :text
  end
end
