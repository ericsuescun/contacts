class BirthDateValidator < ActiveModel::Validator
  def validate(contact)
    if contact.birth_date.to_s.match(/\A\d{4}\-\d{2}\-\d{2}\z/) || contact.birth_date.to_s.match(/\A\d{4}\d{2}\d{2}\z/)
      return true
    else
      contact.errors.add :birth_date, "invalid format"
    end
  end
end