class AddApproveKeyToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :approve_key, :string
    add_index :comments, :approve_key
  end
end
