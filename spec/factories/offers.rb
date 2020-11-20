# frozen_string_literal: true

FactoryBot.define do
  factory :offer do
    advertiser_name { Faker::Food.fruits }
    url { 'https://site.com' }
    description { Faker::Food.description }
    starts_at { Time.current }
    ends_at { Time.current + rand(1..10).days }
    premium { %i[false true].sample }
    disabled { false }
  end
end
