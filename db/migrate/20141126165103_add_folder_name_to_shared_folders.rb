class AddFolderNameToSharedFolders < ActiveRecord::Migration
  def change
    add_column :shared_folders, :folder_name, :string
  end
end
