class RenameAvatarUrlToAvatarInUsers < ActiveRecord::Migration[7.1]
  def change
    rename_column :users, :avatar_url, :avatar
  end
end
