class Micropost < ApplicationRecord
  belongs_to :user
  # lets us order the created_at column... can also be done with SQL syntax: order('created_at DESC')
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader    # adds the uploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
