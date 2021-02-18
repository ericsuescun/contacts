FactoryBot.define do
  factory :source do
    filename { "test.csv" }
    order { nil }
    status { nil }
    association :user
  end
end
