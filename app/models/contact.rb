class Contact < ApplicationRecord
  include ActiveModel::Validations
  belongs_to :user

  validates :name, format: { with: /^[\p{L}\s\p{N}._@?¿!¡€-]+$/, message: "character missmatch", multiline: true }

  # validate :birth_date_format

  # def birth_date_format
  #   if birth_date.to_s.match(/\A\d{4}\-\d{2}\-\d{2}\z/) || birth_date.to_s.match(/\A\d{4}\d{2}\d{2}\z/)
  #     return true
  #   else
  #     errors.add :birth_date, "invalid format"
  #   end
  # end

  validates_with BirthDateValidator

  validate :phone_number_format

  def phone_number_format
    if tel.match(/\(\+\d{1,2}\)\s\d{3,3}-\d{3,3}-\d{2,2}-\d{2,2}/) || tel.match(/\(\+\d{1,2}\)\s\d{3,3}\s\d{3,3}\s\d{2,2}\s\d{2,2}/)
      return true
    else
      errors.add :tel, "phone number format is wrong"
    end
  end

  validates :address, presence: true

  validates :email, format: { with: /\A\S+@\S+\.\S+\z/, message: "has errors" }

end