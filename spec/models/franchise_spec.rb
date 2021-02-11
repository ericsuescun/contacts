require 'rails_helper'

RSpec.describe Franchise, type: :model do
	it "is valid with prefix, name, number_length" do
		franchise = Franchise.new(
			prefix: "34,36, 40-51",
			name: "some name, some & country",
			number_length: "19, 20-24,25"
			)
		expect(franchise).to be_valid
	end

	it "is invalid with long hyphen in prefix" do
		franchise = Franchise.new(
			prefix: "5610, 560221–560225",
			name: "some name",
			number_length: "some number length fields"
			)
		expect(franchise).to be_invalid
	end

	it "is invalid with brackets characters in prefix" do
		franchise = Franchise.new(
			prefix: "5610, 560221-560225[7]",
			name: "some name",
			number_length: "some number length fields"
			)
		expect(franchise).to be_invalid
	end

	it "is invalid with long hyphen character in number length" do
		franchise = Franchise.new(
			prefix: "5610, 560221-560225[7]",
			name: "some name",
			number_length: "19, 20–24,25"
			)
		expect(franchise).to be_invalid
	end

	it "is invalid with brackets characters in number length" do
		franchise = Franchise.new(
			prefix: "5610, 560221-560225[7]",
			name: "some name",
			number_length: "19, 20-24,25[26]"
			)
		expect(franchise).to be_invalid
	end
end
