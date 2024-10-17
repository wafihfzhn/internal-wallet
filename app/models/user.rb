class User < ApplicationRecord
  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true
end
