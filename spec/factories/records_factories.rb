# frozen_string_literal: true

FactoryBot.define do
  factory :record do
    transient { user { create(:user) } }
    account { association :account, user: user }
    category { association :category, user: user }

    sequence(:title) { |n| "Record #{n}" }
    amount_cents { 1000 }
    amount_currency { "BRL" }
    record_type { Records::Types::EXPENSE }
    occurred_in { Time.zone.today }
    payee { "Some Payee" }
    description { "Some Description" }

    trait :income do
      record_type { Records::Types::INCOME }
    end
    trait :expense do
      record_type { Records::Types::EXPENSE }
    end
    traits_for_enum(:record_type, Records::Types.list)
  end
end
