FactoryBot.define do
  factory :import do
    name { "John-Smith" }
    birth_date { "1975-03-25" }
    tel { "(+57) 301 226 83 94" }
    address { "CR CL" }
    credit_card { "5300111122223333" }
    franchise { "" }
    email { "someoneelse@aservice.com" }
    import_errors { "" }
    filename { "" }

    association :user
  end
end
