class AddDefaultValuesToAssets < ActiveRecord::Migration
  def self.up
    change_column :assets, :uploaded_from_web, :string, :default => "0"
    change_column :assets, :is_deleted, :string, :default => "0"
    change_column :assets, :s1, :string, :default => "0"
    change_column :assets, :s2, :string, :default => "0"
    change_column :assets, :s3, :string, :default => "0"
  end

  def self.down
    # You can't currently remove default values in Rails
    raise ActiveRecord::IrreversibleMigration, "Can't remove the default"
  end

end
