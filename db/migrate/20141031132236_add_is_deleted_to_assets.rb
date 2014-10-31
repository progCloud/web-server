class AddIsDeletedToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :is_deleted, :string
  end
end
