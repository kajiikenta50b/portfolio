class SorceryCore < ActiveRecord::Migration[7.1]
  def change
    unless table_exists?(:users)
      create_table :users do |t|
        t.string :email, null: false
        t.string :crypted_password
        t.string :salt
        t.string :username
        t.string :faction
        t.integer :rank_id
        t.string :avatar

        t.timestamps null: false
      end

      add_index :users, :email, unique: true
    else
      add_column :users, :crypted_password, :string unless column_exists?(:users, :crypted_password)
      add_column :users, :salt, :string unless column_exists?(:users, :salt)
    end
  end
end
