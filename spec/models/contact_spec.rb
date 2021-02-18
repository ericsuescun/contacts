require 'rails_helper'

RSpec.describe Contact, type: :model do

  before(:each) do
    Import.destroy_all
    Contact.destroy_all
  end

  it "is valid with name, birth_date, tel, address, credit_card, franchise, email" do
    contact = build(:contact)
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

    it "is valid with franchise match and correct length variation 12" do
      expect(build(:contact, credit_card: "676770112233")).to be_valid
    end

    it "is invalid with franchise match and wrong length variation under 12" do
      expect(build(:contact, credit_card: "67677011223")).to be_invalid
    end

    it "is valid with franchise match and correct length variation 19" do
      expect(build(:contact, credit_card: "6767701122334455667")).to be_valid
    end

    it "is valid with franchise match and correct length variation over 19" do
      expect(build(:contact, credit_card: "67677011223344556678")).to be_invalid
    end

    it "is valid with franchise match and correct length" do
      expect(build(:contact, credit_card: "5100111122223333")).to be_valid
    end

    it "is valid with franchise match, correct length and franchise name Mastercard" do
      contact = build(:contact, credit_card: "5100111122223333")
      contact.valid?
      expect(contact.franchise).to include("Mastercard")
    end

    it "is valid with franchise match, correct length and franchise name Maestro UK" do
      contact = build(:contact, credit_card: "676770112233")
      contact.valid?
      expect(contact.franchise).to include("Maestro UK")
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

  context "with Active Job contact creation" do
    it "creates 3 valid contacts and extracts 3 import records" do

      3.times{|n| create(:import)}
      init_imports = Import.count
      init_contacts = Contact.count
      import_file = create(:source)
      import_ids = Import.ids
      CreateContactsFromImportJob.perform_now(
          import_ids,
          Import.take(1).first.user,
          "name",
          "birth_date",
          "tel",
          "address",
          "credit_card",
          "email"
        )
      expect(init_imports - Import.count).to eq 3
      expect(Contact.count - init_contacts ).to eq 3
    end

    it "creates no contacts and imports remain the same" do

      3.times{|n| create(:import)}
      init_imports = Import.count
      init_contacts = Contact.count
      import_file = create(:source)
      import_ids = Import.ids
      CreateContactsFromImportJob.perform_now(
          import_ids,
          Import.take(1).first.user,
          "name",
          "tel",
          "birth_date",
          "address",
          "credit_card",
          "email"
        )
      expect(init_imports - Import.count).to eq 0
      expect(Contact.count - init_contacts ).to eq 0
    end

    it "creates 2 valid contacts and leaves 1 import record with email error" do
      2.times{|n| create(:import)}
      failed_import = create(:import, email: "someone@somwhere")
      init_imports = Import.count
      init_contacts = Contact.count
      import_file = create(:source)
      import_ids = Import.ids
      CreateContactsFromImportJob.perform_now(
          import_ids,
          Import.take(1).first.user,
          "name",
          "birth_date",
          "tel",
          "address",
          "credit_card",
          "email"
        )
      expect(Import.count).to eq 1
      expect(Contact.count - init_contacts ).to eq 2
      # expect(failed_import.import_errors).to include("Email has errors")
      expect(Import.where(email: "someone@somwhere").first.import_errors).to include("Email has errors")
    end
  end
end
