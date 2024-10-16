# frozen_string_literal: true

require "rails_helper"

RSpec.describe Record, type: :model do
  describe "monetization" do
    it "monetizes amount attributes" do
      record = described_class.new(amount_cents: 1000, amount_currency: "BRL")

      expect(record.amount).to eq(Money.new(1000, "BRL"))
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:account) }
    it { is_expected.to belong_to(:category).optional }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:amount_cents) }
    it { is_expected.to validate_presence_of(:amount_currency) }
    it { is_expected.to validate_presence_of(:record_type) }
    it { is_expected.to validate_presence_of(:occurred_in) }

    it { is_expected.to validate_length_of(:title).is_at_most(70) }
    it { is_expected.to validate_length_of(:payee).is_at_most(70) }
    it { is_expected.to validate_length_of(:description).is_at_most(100) }

    it { is_expected.to validate_numericality_of(:amount_cents).is_greater_than_or_equal_to(0) }
  end

  describe ".enumerations" do
    it "has enumerations for record_types" do
      expect(described_class.enumerations).to include(record_type: Records::Types)
    end
  end
end
