require 'rails_helper'

RSpec.describe Franchise, type: :model do
	it "is valid with prefix, name, number_length" do
		expect(build(:franchise)).to be_valid
	end

	it "is invalid with long hyphen in prefix" do
		expect(build(:franchise, prefix: "5610, 560221–560225")).to be_invalid
	end

	it "is invalid with brackets characters in prefix" do
		expect(build(:franchise, prefix: "5610, 560221-560225[7]")).to be_invalid
	end

	it "is invalid with long hyphen character in number length" do
		expect(build(:franchise, number_length: "19, 20–24,25")).to be_invalid
	end

	it "is invalid with brackets characters in number length" do
		expect(build(:franchise, number_length: "19, 20-24,25[26]")).to be_invalid
	end
end
