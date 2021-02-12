FactoryBot.define do
  sequence :email do |n|
    "email#{n}@algo.com"
  end
end