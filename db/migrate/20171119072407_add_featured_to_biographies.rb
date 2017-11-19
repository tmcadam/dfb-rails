class AddFeaturedToBiographies < ActiveRecord::Migration[5.1]
  def change
    add_column :biographies, :featured, :boolean
  end
end
