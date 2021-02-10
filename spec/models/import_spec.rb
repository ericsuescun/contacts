require 'rails_helper'

RSpec.describe Import, type: :model do
	before do
		@user = User.create(
			email: "someone@aservice.com",
			password: "12345678"
			)
	end

	it "is valid with name, birth_date, tel, address, credit_card, franchise, email, import_errors, filename" do
		import = Import.new(
			user_id: @user.id,
			name: "John-Smith",
			birth_date: "1975-03-25",
			tel: "(+57) 301 226 83 94",
			address: "CR CL",
			credit_card: "5300111122223333",
			franchise: "",
			email: "someoneelse@aservice.com",
			import_errors: "",
			filename: ""
			)
		expect(import).to be_valid
	end
end
