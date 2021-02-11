class Source < ApplicationRecord
  belongs_to :user

  validates :filename, presence: true
  validates :filename, format: { with: /\A\w+\.\w{3}\Z/ }
end
