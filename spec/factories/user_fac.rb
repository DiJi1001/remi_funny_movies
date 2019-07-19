FactoryBot.define do
  factory :user do
    sequence :email do |index|
      "eddie.redmayne_#{index}@gmail.com"
    end
    password { Faker::Internet.password(6, 20) }
  end
end
