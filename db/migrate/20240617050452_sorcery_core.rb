class SorceryCore < ActiveRecord::Migration[7.1]
  def change
    unless table_exists?(:users)
      create_table :users do |t|
        t.string :email,            null: false, index: { unique: true }
        t.string :crypted_password
        t.string :salt
        t.string :username
        t.integer :faction
        t.bigint :rank_id
        t.string :avatar_url

        t.timestamps                null: false
      end
    end
  end
end
