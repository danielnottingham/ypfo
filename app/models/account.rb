# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :user

  validates :balance_cents, presence: true
  validates :balance_currency, presence: true
  validates :color, presence: true
  validates :title, presence: true

  validates :title, length: { maximum: 50 }

  validates :title, uniqueness: { scope: :user_id }

  validates :color, format: { with: /\A#[a-fA-F0-9]{6}\z/, allow_blank: true }
end
