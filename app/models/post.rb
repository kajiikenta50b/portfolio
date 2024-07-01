class Post < ApplicationRecord
  mount_uploader :post_image, PostImageUploader

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }
  validates :post_image, presence: true

  belongs_to :user
  has_many :comments, dependent: :destroy
end
