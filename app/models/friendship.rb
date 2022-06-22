class Friendship < ApplicationRecord
	belongs_to :friend, foreign_key: :friend_id, class_name: "User"
	belongs_to :users_friend, foreign_key: :user_id, class_name: "User"

	validates :user_id, presence: true
	validates :friend_id, presence: true

	scope :users_friends, ->(id) {where("friend_id =? or user_id =?", id, id)}
end
