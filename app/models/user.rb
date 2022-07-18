class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
end
