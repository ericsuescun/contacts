class Contact < ApplicationRecord
  belongs_to :user

  validates :name, format: { with: /^[\p{L}\s\p{N}._@?¿!¡€-]+$/, message: "character missmatch", multiline: true }

  # validates :birth_date, presence: true
  validates :birth_date, format: { with: /\A\d{4}-\d{2}-\d{2}\Z/ || /\A\d{4}\d{2}\d{2}\Z/, message: "invalid format" }

  validates :tel, format: { with: /\(\+\d{1,2}\)\s\d{3,3}\s\d{3,3}\s\d{2,2}\s\d{2,2}/, message: "phone number format is wrong" }

  validates :address, presence: true

  validates :email, format: { with: /\A\S+@\S+\.\S+\Z/, message: "has errors", multiline: true }

end
