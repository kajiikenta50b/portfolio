class Post < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }
  validates :image_url, presence: true

  belongs_to :user

  mount_uploader :post_image, PostImageUploader
end
