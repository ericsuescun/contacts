FactoryBot.define do
  factory :source do
    filename { "somename.ext" }
    order { nil }
    status { nil }
    association :user
  end
end
