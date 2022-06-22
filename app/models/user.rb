class User < ApplicationRecord
  
	has_many :friendships
	has_many :active_relationships, class_name: "Friendship", foreign_key: "friend_id"
	has_many :passive_relationships, class_name: "Friendship", foreign_key: "user_id"
	has_many :ouer_friends, through: :active_relationships, source: :users_friend
  has_many :requested_friends, through: :passive_relationships, source: :friend

  validates :name, presence: true
  validates :email, presence: true
  validates :web_url, presence: true

  # my_lambda = lambda { where(id) }

  has_secure_password

end
