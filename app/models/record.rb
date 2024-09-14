# frozen_string_literal: true

class Record < ApplicationRecord
  belongs_to :account

  validates :title, presence: true
  validates :amount_cents, presence: true
  validates :amount_currency, presence: true
  validates :occurred_in, presence: true
  validates :record_type, presence: true

  validates :amount_cents, numericality: { greater_than_or_equal_to: 0 }

  validates :title, length: { maximum: 70 }
  validates :payee, length: { maximum: 70 }
  validates :description, length: { maximum: 100 }
end
