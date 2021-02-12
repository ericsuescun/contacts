FactoryBot.define do
  factory :user do
    email
    password { "12345678" }
  end
end
