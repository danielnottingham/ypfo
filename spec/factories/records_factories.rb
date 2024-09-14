# frozen_string_literal: true

FactoryBot.define do
  factory :record do
    transient { user { create(:user) } }
    account { association :account, user: user }

    sequence(:title) { |n| "Record #{n}" }
    amount_cents { 1000 }
    amount_currency { "BRL" }
    record_type { 1 }
    occurred_in { Time.zone.today }
    payee { "Some Payee" }
    description { "Some Description" }
  end
end
