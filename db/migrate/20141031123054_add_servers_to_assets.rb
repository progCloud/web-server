class AddServersToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :s1, :string
    add_column :assets, :s2, :string
    add_column :assets, :s3, :string
  end
end
