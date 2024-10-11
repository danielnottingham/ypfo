# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    user

    sequence(:title) { |n| "Category #{n}" }
    color { "#ffffff" }
  end
end
