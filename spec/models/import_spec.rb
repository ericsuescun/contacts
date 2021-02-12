require 'rails_helper'

RSpec.describe Import, type: :model do
	it "is valid with name, birth_date, tel, address, credit_card, franchise, email, import_errors, filename" do
		expect(build(:import)).to be_valid
	end
end
