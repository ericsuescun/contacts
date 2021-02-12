require 'rails_helper'

RSpec.describe Source, type: :model do

	before do
		@user = User.create(
			email: "someone@aservice.com",
			password: "12345678"
			)
	end

	it "is valid with filename and 3 characters extension" do
		source = @user.sources.build(
			filename: "somename.ext",
			order: nil,
			status: nil
			)
	expect(source).to be_valid
	end

	it "is invalid without 3 characters extension" do
		source = @user.sources.build(
			filename: "somename",
			order: nil,
			status: nil
			)
	expect(source).to be_invalid
	end
end
