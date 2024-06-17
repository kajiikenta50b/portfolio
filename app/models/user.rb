class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :username, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true

  has_many :posts, dependent: :destroy

  enum faction: { rice: 0, noodle: 1, bread: 2 }
end
