require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with email and password" do
    expect(build(:user)).to be_valid
  end
  it "is invalid with empty email" do
  	user = build(:user, email: '')
  	user.valid?
  	expect(user.errors[:email]).to include("can't be blank")
  end
  it "is invalid with password length under 6 characters" do
    expect(build(:user, password: "12345")).to be_invalid
  end
  it "is invalid with a duplicate email" do
  	# user1 = User.create(
  	# 	email: "someone@aservice.com",
  	# 	password: "12345678"
  	# 	)
  	# user2 = User.new(
  	# 	email: "someone@aservice.com",
  	# 	password: "87654321"
  	# 	)
  	# user2.valid?
  	# expect(user2.errors[:email]).to include("has already been taken")
    user1 = create(:user)
    user2 = build(:user, email: user1.email)
    user2.valid?
    expect(user2.errors[:email]).to include("has already been taken")
  end

  after do
    User.destroy_all
  end
end
