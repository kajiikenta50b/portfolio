class RemoveSaltFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :salt, :string
  end
end
