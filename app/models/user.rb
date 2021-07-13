class User < ApplicationRecord
  validates :public_address, presence: true, uniqueness: true
end
