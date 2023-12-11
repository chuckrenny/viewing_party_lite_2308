require "factory_bot_rails"
require "faker"

FactoryBot.define do
  pass = Faker::Internet.password
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email(name: name, separators: ["+"]) }
    password { pass }
    password_confirmation { pass }
  end
end
