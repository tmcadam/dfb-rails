class AddDimsToImages < ActiveRecord::Migration[6.1]
  def change
    add_column :images, :dim_x, :integer
    add_column :images, :dim_y, :integer
    Image.all.each do |image|
      image.save
    end
  end
end