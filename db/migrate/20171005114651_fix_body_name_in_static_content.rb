class FixBodyNameInStaticContent < ActiveRecord::Migration[5.1]
  def change
      rename_column :static_contents, :text, :body
  end
end
