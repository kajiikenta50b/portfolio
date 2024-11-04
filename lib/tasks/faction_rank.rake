namespace :faction_rank do
  desc "Calculate top faction for the past week"
  task calculate_top: :environment do
    top_faction = Post.top_faction
    TopFaction.create(faction: top_faction, calculated_at: Time.current)

    puts "Top faction for the past week: #{top_faction}"
  end
end