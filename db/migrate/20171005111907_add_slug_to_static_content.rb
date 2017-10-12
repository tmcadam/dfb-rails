class AddSlugToStaticContent < ActiveRecord::Migration[5.1]
  def change
    add_column :static_contents, :slug, :string
  end
end
