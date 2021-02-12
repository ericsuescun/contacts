require 'rails_helper'

RSpec.describe Source, type: :model do
	it "is valid with filename and 3 characters extension" do
		expect(build(:source)).to be_valid
	end

	it "is invalid without 3 characters extension" do
		expect(build(:source, filename: "somename")).to be_invalid
	end
end
