require 'rails_helper'

RSpec.describe Contact, type: :model do

  it "is valid with name, birth_date, tel, address, credit_card, franchise, email" do
    contact = build(:contact)
    puts "Contact info: #{contact.user.inspect}"
    expect(contact).to be_valid
  end

  it "is invalid with special characters except - in name" do
    contact = build(:contact, name: "John $!#%&/()[]{}?¿¡_;:+*^ Smith")
    contact.valid?
    expect(contact.errors[:name]).to include("character missmatch")
  end

  context "with birth date figures present" do
    it "is valid without characters in between" do
      expect(build(:contact, birth_date: "19750325")).to be_valid
    end

    it "is valid with - characters in between" do
      expect(build(:contact, birth_date: "1975-03-25")).to be_valid
    end

    it "is valid with / characters in between" do
      expect(build(:contact, birth_date: "1975/03/25")).to be_valid
    end

    it "is invalid with characters (including spaces) in between" do
      contact = build(:contact, birth_date: "1975 03:25")
      contact.valid?
      expect(contact.errors[:birth_date]).to include("invalid format")
    end

    it "is invalid with one hyphen in between" do
      contact = build(:contact, birth_date: "1975-03 25")
      contact.valid?
      expect(contact.errors[:birth_date]).to include("invalid format")
    end

    it "is invalid without separators and length less than 8" do
      contact = build(:contact, birth_date: "1975035")
      contact.valid?
      expect(contact.errors[:birth_date]).to include("invalid format")
    end

    it "is invalid without separators and length more than 8" do
      contact = build(:contact, birth_date: "197503257")
      contact.valid?
      expect(contact.errors[:birth_date]).to include("invalid format")
    end
  end

  context "credid card validations" do
    it "is valid with franchise match and correct length" do
      expect(build(:contact, credit_card: "5100111122223333")).to be_valid
    end

    it "is invalid with franchise missmatch" do
      contact = build(:contact, credit_card: "0000111122223333")
      contact.valid?
      expect(contact.errors[:credit_card]).to include("is invalid")
    end

    it "is invalid with franchise match and wrong length (plus)" do
      contact = build(:contact, credit_card: "51001111222233334")
      contact.valid?
      expect(contact.errors[:credit_card]).to include("is invalid")
    end

    it "is invalid with franchise match and wrong length (minus)" do
      contact = build(:contact, credit_card: "510011112222000")
      contact.valid?
      expect(contact.errors[:credit_card]).to include("is invalid")
    end


  end

  context "with tel phone number figures present" do
    it "is valid with hyphens between last groups" do
      expect(build(:contact, tel: "(+57) 301-226-83-94")).to be_valid
    end

    it "is valid with single digit country code" do
      expect(build(:contact, tel: "(+1) 301-226-83-94")).to be_valid
    end

    it "is invalid without characters between last groups" do
      contact = build(:contact, tel: "(+57) 3012268394")
      contact.valid?
      expect(contact.errors[:tel]).to include("phone number format is wrong")
    end

    it "is invalid without some hyphens between groups" do
      contact = build(:contact, tel: "(+57) 301-226 83 94")
      contact.valid?
      expect(contact.errors[:tel]).to include("phone number format is wrong")
    end

    it "is invalid without country code" do
      contact = build(:contact, tel: "3012268394")
      contact.valid?
      expect(contact.errors[:tel]).to include("phone number format is wrong")
    end

    it "is invalid with wrong digits in area code" do
      contact = build(:contact, tel: "(+57) 31-226-83-94")
      contact.valid?
      expect(contact.errors[:tel]).to include("phone number format is wrong")
    end

    it "is invalid with wrong digits in first group after area code" do
      contact = build(:contact, tel: "(+57) 31-26-83-94")
      contact.valid?
      expect(contact.errors[:tel]).to include("phone number format is wrong")
    end

    it "is invalid with wrong digits in second group after area code" do
      contact = build(:contact, tel: "(+57) 31-226-3-94")
      contact.valid?
      expect(contact.errors[:tel]).to include("phone number format is wrong")
    end

    it "is invalid with wrong digits in third group after area code" do
      contact = build(:contact, tel: "(+57) 31-226-83-4")
      contact.valid?
      expect(contact.errors[:tel]).to include("phone number format is wrong")
    end
  end

  it "is invalid with address empty" do
    contact = build(:contact, address: "")
    contact.valid?
    expect(contact.errors[:address]).to include("can't be blank")
  end

  context "with email not empty" do
    it "is invalid with no domain name" do
      contact = build(:contact, email: "someoneelse@.com")
      contact.valid?
      expect(contact.errors[:email]).to include("has errors")
    end

    it "is invalid with no domain" do
      contact = build(:contact, email: "someoneelse@aservice.")
      contact.valid?
      expect(contact.errors[:email]).to include("has errors")
    end
  end
end
