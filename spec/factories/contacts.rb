FactoryBot.define do
  factory :contact do
    name { "John-Smith" }
    birth_date { "1975-03-25" }
    tel { "(+57) 301 226 83 94" }
    address { "CR CL" }
    credit_card { "5100111122223333" }

    email

    association :user
  end
end