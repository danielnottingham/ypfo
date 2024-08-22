# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    user

    sequence(:title) { |n| "Account #{n}" }
    balance_cents { 0 }
    balance_currency { "BRL" }
    color { "#ffffff" }
  end
end
