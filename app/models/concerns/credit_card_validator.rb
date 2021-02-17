class CreditCardValidator < ActiveModel::Validator
  require 'franchises_data'

  def validate(contact)
    if get_franchise(contact.credit_card) == []
      contact.errors.add :credit_card, "is invalid"
    end
  end

  def get_franchise(card_number)
    franchises = FranchisesData::FRANCHISES

    result = []
    franchises_with_prefix = franchises.map do |key, value|
      value[:prefix].each do |prefix|
        result << [prefix, key, value[:length]]
      end
    end
    result.compact!
    # p result
    # p franchises_with_prefix
    options = result.select{|data| card_number.to_s.start_with?(data[0].to_s) && card_number.length == data[2].find{|length| card_number.length == length } }
  end
end
