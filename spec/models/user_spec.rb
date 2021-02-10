require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with email and password" do
  	user = User.new(
  		email: "edsa@hotmail.com",
  		password: "12345678"
  		)
  	expect(user).to be_valid
  end
  it "is invalid with empty email" do
  	user = User.new(
  		email: "",
  		password: "12345678"
  		)
  	expect(user).to be_invalid
  end
  it "is invalid with password length under 6" do
  	user = User.new(
  		email: "edsa@hotmail.com",
  		password: "12345"
  		)
  	expect(user).to be_invalid
  end
  it "is invalid with a duplicate email" 
end
