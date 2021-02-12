FactoryBot.define do
  factory :franchise do
    prefix { "34,36, 40-51" }
    name { "some name, some & country" }
    number_length { "19, 20-24,25" }
  end
end
