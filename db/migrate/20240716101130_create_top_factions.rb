class CreateTopFactions < ActiveRecord::Migration[7.1]
  def change
    create_table :top_factions do |t|
      t.string :faction
      t.datetime :calculated_at

      t.timestamps
    end
  end
end
