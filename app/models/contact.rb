class Contact < ApplicationRecord
  include ActiveModel::Validations

  require 'concerns/franchises_data'
  require 'bcrypt'

  belongs_to :user

  validates :name, format: { with: /^[\p{L}\s\p{N}._@?¿!¡€-]+$/, message: "character missmatch", multiline: true }

  validates_with BirthDateValidator, CreditCardValidator

  # after_validation :set_franchise_name, :encrypt_credit_card, :set_4_credit_card_number
  after_validation :set_franchise_name, :encrypt_credit_card

  validate :phone_number_format

  def phone_number_format
    unless tel.match(/\(\+\d{1,2}\)\s\d{3,3}-\d{3,3}-\d{2,2}-\d{2,2}/) || tel.match(/\(\+\d{1,2}\)\s\d{3,3}\s\d{3,3}\s\d{2,2}\s\d{2,2}/)
      errors.add :tel, "phone number format is wrong"
    end
  end

  validates :address, presence: true

  validates :email, format: { with: /\A\S+@\S+\.\S+\z/, message: "has errors" }

  def set_franchise_name
    self.franchise = Franchise.name_from_number(self.credit_card)
  end

  def encrypt_credit_card
    self.cc_digest =BCrypt::Password.create(self.credit_card)
  end

  def set_4_credit_card_number
    self.credit_card = self.credit_card[-4..-1]
  end

  def creditcard_secure
    credit_card[-4..-1]
  end

end