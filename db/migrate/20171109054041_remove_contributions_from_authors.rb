class RemoveContributionsFromAuthors < ActiveRecord::Migration[5.1]
  def change
    remove_column :authors, :contributions, :text
  end
end
