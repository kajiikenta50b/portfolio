class Post < ApplicationRecord
  belongs_to :user
  mount_uploader :post_image, PostImageUploader

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }
  validates :post_image, presence: true

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  scope :from_last_week, -> { where(created_at: 1.week.ago.beginning_of_day..Time.current.end_of_day) }

  def self.top_faction
    faction_counts = from_last_week.joins(:user).group("users.faction").order('count_id DESC').count(:id)

    # 新規投稿数でのトップを取得
    top_factions = faction_counts.select { |_, v| v == faction_counts.values.max }.keys

    if top_factions.size == 1
      top_factions.first
    else
      User.top_faction_by_new_users(top_factions)
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["body", "created_at", "id", "title", "updated_at", "user_id"]
  end
end
