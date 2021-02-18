FactoryBot.define do
  factory :import do
    name { "Jon Doe" }
    birth_date { "1975-03-25" }
    tel { "(+57) 301 226 83 94" }
    address { "CR CL" }
    credit_card { "5100111122223333" }
    franchise { "" }
    email
    import_errors { "" }
    filename { "test.csv" }

    association :user
  end
end
