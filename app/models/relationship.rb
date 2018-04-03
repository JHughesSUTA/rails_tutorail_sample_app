class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true    # not needed in rails 5
  validates :followed_id, presence: true    # not needed in rails 5
end
