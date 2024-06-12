class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.integer :faction
      t.bigint :rank_id
      t.string :avatar_url

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
