class CreateBiographyAuthorsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :biography_authors do |t|
        t.belongs_to :biography, index: true
        t.belongs_to :author, index: true
        t.integer :author_position
        t.timestamps
    end
  end
end
