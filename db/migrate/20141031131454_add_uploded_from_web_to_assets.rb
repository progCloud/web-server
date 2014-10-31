class AddUplodedFromWebToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :uploaded_from_web, :string
  end
end
