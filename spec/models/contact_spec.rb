require 'rails_helper'

RSpec.describe Contact, type: :model do

	before do
		@user = User.create(
			email: "someone@aservice.com",
			password: "12345678"
			)
	end

	it "is valid with name, birth_date, tel, address, credit_card, franchise, email" do
		contact = @user.contacts.build(
			name: "John-Smith",
			birth_date: "1975-03-25",
			tel: "(+57) 301 226 83 94",
			address: "CR CL",
			credit_card: "5300111122223333",
			franchise: "",
			email: "someoneelse@aservice.com"
			)
		expect(contact).to be_valid
	end

	it "is invalid with special characters except - in name" do
		contact = @user.contacts.build(
			name: "John $!#%&/()[]{}?¿¡_;:+*^ Smith",
			birth_date: "1975-03-25",
			tel: "(+57) 301 226 83 94",
			address: "CR CL",
			credit_card: "5300111122223333",
			franchise: "",
			email: "someoneelse@aservice.com"
			)
		contact.valid?
		expect(contact.errors[:name]).to include("character missmatch")
	end

	context "with birth date figures present" do
		it "is valid without characters in between" do
			contact = @user.contacts.build(
				name: "John Smith",
				birth_date: "19750325",
				tel: "(+57) 301 226 83 94",
				address: "CR CL",
				credit_card: "5300111122223333",
				franchise: "",
				email: "someoneelse@aservice.com"
				)
			expect(contact).to be_valid
		end

		it "is valid with - characters in between" do
			contact = @user.contacts.build(
				name: "John Smith",
				birth_date: "1975-03-25",
				tel: "(+57) 301 226 83 94",
				address: "CR CL",
				credit_card: "5300111122223333",
				franchise: "",
				email: "someoneelse@aservice.com"
				)
			expect(contact).to be_valid
		end

		it "is valid with / characters in between" do
			contact = @user.contacts.build(
				name: "John Smith",
				birth_date: "1975/03/25",
				tel: "(+57) 301 226 83 94",
				address: "CR CL",
				credit_card: "5300111122223333",
				franchise: "",
				email: "someoneelse@aservice.com"
				)
			expect(contact).to be_valid
		end

		it "is invalid with characters (including spaces) in between" do
			contact = @user.contacts.build(
				name: "John Smith",
				birth_date: "1975 03:25",
				tel: "(+57) 301 226 83 94",
				address: "CR CL",
				credit_card: "5300111122223333",
				franchise: "",
				email: "someoneelse@aservice.com"
				)
			contact.valid?
			expect(contact.errors[:birth_date]).to include("invalid format")
		end

		it "is invalid without separators and length less than 8" do
			contact = @user.contacts.build(
				name: "John Smith",
				birth_date: "1975035",
				tel: "(+57) 301 226 83 94",
				address: "CR CL",
				credit_card: "5300111122223333",
				franchise: "",
				email: "someoneelse@aservice.com"
				)
			contact.valid?
			expect(contact.errors[:birth_date]).to include("invalid format")
		end

		it "is invalid without separators and length more than 8" do
			contact = @user.contacts.build(
				name: "John Smith",
				birth_date: "197503257",
				tel: "(+57) 301 226 83 94",
				address: "CR CL",
				credit_card: "5300111122223333",
				franchise: "",
				email: "someoneelse@aservice.com"
				)
			contact.valid?
			expect(contact.errors[:birth_date]).to include("invalid format")
		end
	end

	context "with tel phone number figures present" do
		it "is valid with hyphens between last groups" do
			contact = @user.contacts.build(
				name: "John Smith",
				birth_date: "1975-03-25",
				tel: "(+57) 301-226-83-94",
				address: "CR CL",
				credit_card: "5300111122223333",
				franchise: "",
				email: "someoneelse@aservice.com"
				)
			expect(contact).to be_valid
		end

		it "is valid with single digit country code" do
			contact = @user.contacts.build(
				name: "John Smith",
				birth_date: "1975-03-25",
				tel: "(+1) 301-226-83-94",
				address: "CR CL",
				credit_card: "5300111122223333",
				franchise: "",
				email: "someoneelse@aservice.com"
				)
			expect(contact).to be_valid
		end

		it "is invalid without characters between last groups" do
			contact = @user.contacts.build(
				name: "John Smith",
				birth_date: "1975-03-25",
				tel: "(+57) 3012268394",
				address: "CR CL",
				credit_card: "5300111122223333",
				franchise: "",
				email: "someoneelse@aservice.com"
				)
			contact.valid?
			expect(contact.errors[:tel]).to include("phone number format is wrong")
		end

		it "is invalid without country code" do
			contact = @user.contacts.build(
				name: "John Smith",
				birth_date: "1975-03-25",
				tel: "3012268394",
				address: "CR CL",
				credit_card: "5300111122223333",
				franchise: "",
				email: "someoneelse@aservice.com"
				)
			contact.valid?
			expect(contact.errors[:tel]).to include("phone number format is wrong")
		end

		it "is invalid with wrong digits in area code" do
			contact = @user.contacts.build(
				name: "John Smith",
				birth_date: "1975-03-25",
				tel: "(+57) 31-226-83-94",
				address: "CR CL",
				credit_card: "5300111122223333",
				franchise: "",
				email: "someoneelse@aservice.com"
				)
			contact.valid?
			expect(contact.errors[:tel]).to include("phone number format is wrong")
		end

		it "is invalid with wrong digits in first group after area code" do
			contact = @user.contacts.build(
				name: "John Smith",
				birth_date: "1975-03-25",
				tel: "(+57) 301-26-83-94",
				address: "CR CL",
				credit_card: "5300111122223333",
				franchise: "",
				email: "someoneelse@aservice.com"
				)
			contact.valid?
			expect(contact.errors[:tel]).to include("phone number format is wrong")
		end

		it "is invalid with wrong digits in second group after area code" do
			contact = @user.contacts.build(
				name: "John Smith",
				birth_date: "1975-03-25",
				tel: "(+57) 301-226-3-94",
				address: "CR CL",
				credit_card: "5300111122223333",
				franchise: "",
				email: "someoneelse@aservice.com"
				)
			contact.valid?
			expect(contact.errors[:tel]).to include("phone number format is wrong")
		end

		it "is invalid with wrong digits in third group after area code" do
			contact = @user.contacts.build(
				name: "John Smith",
				birth_date: "1975-03-25",
				tel: "(+57) 301-226-83-4",
				address: "CR CL",
				credit_card: "5300111122223333",
				franchise: "",
				email: "someoneelse@aservice.com"
				)
			contact.valid?
			expect(contact.errors[:tel]).to include("phone number format is wrong")
		end
	end

	it "is invalid with address empty" do
		contact = @user.contacts.build(
			name: "John Smith",
			birth_date: "1975-03-25",
			tel: "(+57) 301-226-83-94",
			address: "",
			credit_card: "5300111122223333",
			franchise: "",
			email: "someoneelse@aservice.com"
			)
		contact.valid?
		expect(contact.errors[:address]).to include("can't be blank")
	end

	context "with email not empty" do
		it "is invalid with no username" do
			contact = @user.contacts.build(
				name: "John Smith",
				birth_date: "1975-03-25",
				tel: "(+57) 301-226-83-94",
				address: "CL CR",
				credit_card: "5300111122223333",
				franchise: "",
				email: "@aservice.com"
				)
			contact.valid?
			expect(contact.errors[:email]).to include("has errors")
		end

		it "is invalid with no domain name" do
			contact = @user.contacts.build(
				name: "John Smith",
				birth_date: "1975-03-25",
				tel: "(+57) 301-226-83-94",
				address: "CL CR",
				credit_card: "5300111122223333",
				franchise: "",
				email: "someoneelse@.com"
				)
			contact.valid?
			expect(contact.errors[:email]).to include("has errors")
		end

		it "is invalid with no domain" do
			contact = @user.contacts.build(
				name: "John Smith",
				birth_date: "1975-03-25",
				tel: "(+57) 301-226-83-94",
				address: "CL CR",
				credit_card: "5300111122223333",
				franchise: "",
				email: "someoneelse@aservice."
				)
			contact.valid?
			expect(contact.errors[:email]).to include("has errors")
		end
	end

	after do
		User.where(
			email: "someone@aservice.com"
			).first.destroy
	end

end
