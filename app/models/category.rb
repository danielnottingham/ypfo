# frozen_string_literal: true

class Category < ApplicationRecord
  belongs_to :user

  has_many :records, dependent: :nullify

  validates :title, presence: true
  validates :color, presence: true

  validates :title, uniqueness: { scope: :user_id }

  validates :title, length: { maximum: 40 }

  validates :color, format: { with: /\A#[a-fA-F0-9]{6}\z/ }
end
