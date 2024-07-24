class User < ApplicationRecord
  authenticates_with_sorcery!
  mount_uploader :avatar, AvatarUploader

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :username, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  enum faction: { rice: 0, noodle: 1, bread: 2 }

  scope :from_last_week, -> { where(created_at: 1.week.ago.beginning_of_day..Time.current.end_of_day) }

  def self.factions_i18n
    factions.keys.each_with_object({}) do |faction, hash|
      hash[faction.to_sym] = I18n.t("activerecord.attributes.enums.user.faction.#{faction}")
    end
  end

  def self.top_faction_by_new_users(factions)
    user_counts = from_last_week.where(faction: factions).group(:faction).count
    top_factions = user_counts.select { |_, v| v == user_counts.values.max }.keys

    if top_factions.size == 1
      top_factions.first
    else
      top_faction_by_total_users(top_factions)
    end
  end

  def self.top_faction_by_total_users(factions)
    total_user_counts = where(faction: factions).group(:faction).count
    top_faction = total_user_counts.max_by { |_, v| v }
    top_faction ? top_faction.first : nil
  end

  def own?(object)
    id == object&.user_id
  end

  def like(post)
    liked_posts << post
  end

  def unlike(post)
    liked_posts.destroy(post)
  end

  def like?(post)
    liked_posts.include?(post)
  end
end