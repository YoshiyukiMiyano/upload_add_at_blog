class Blog < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: :user
  has_many :users
  belongs_to :user

  validates :title, presence: true
end
