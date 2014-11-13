class AddIsPublicToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :is_public, :boolean, default: false
  end
end
