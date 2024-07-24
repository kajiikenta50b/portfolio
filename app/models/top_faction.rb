class TopFaction < ApplicationRecord
  def self.last_week_top_faction
    where(calculated_at: 1.week.ago.beginning_of_week..Time.current.end_of_week).order(calculated_at: :desc).first&.faction.to_sym
  end
end