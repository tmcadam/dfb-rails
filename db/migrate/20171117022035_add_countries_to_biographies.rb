class AddCountriesToBiographies < ActiveRecord::Migration[5.1]
  def change
      add_column :biographies, :primary_country_id, :integer, index: true
      add_foreign_key :biographies, :countries, column: :primary_country_id

      add_column :biographies, :secondary_country_id, :integer, index: true
      add_foreign_key :biographies, :countries, column: :secondary_country_id

      add_column :biographies, :south_georgia, :boolean
  end
end
