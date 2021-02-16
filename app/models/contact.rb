class Contact < ApplicationRecord
  include ActiveModel::Validations
  belongs_to :user

  validates :name, format: { with: /^[\p{L}\s\p{N}._@?¿!¡€-]+$/, message: "character missmatch", multiline: true }

  validates_with BirthDateValidator

  validate :phone_number_format

  def phone_number_format
    unless tel.match(/\(\+\d{1,2}\)\s\d{3,3}-\d{3,3}-\d{2,2}-\d{2,2}/) || tel.match(/\(\+\d{1,2}\)\s\d{3,3}\s\d{3,3}\s\d{2,2}\s\d{2,2}/)
      errors.add :tel, "phone number format is wrong"
    end
  end

  validates :address, presence: true

  validates :email, format: { with: /\A\S+@\S+\.\S+\z/, message: "has errors" }

end