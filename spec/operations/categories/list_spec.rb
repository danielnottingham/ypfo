# frozen_string_literal: true

require "rails_helper"

RSpec.describe Categories::List, type: :operation do
  describe ".result" do
    it "is successful" do
      create_list(:category, 3)

      result = described_class.result

      expect(result).to be_success
    end

    it "returns categories ordered by created_at desc" do
      category_four = create(:category, created_at: Time.zone.yesterday, title: "Four")
      category_one = create(:category, created_at: Time.zone.today, title: "One")
      category_two = create(:category, created_at: Time.zone.today, title: "Two")
      category_three = create(:category, created_at: Time.zone.tomorrow, title: "Three")
      expected_result = [category_three, category_one, category_two, category_four]

      result = described_class.result

      expect(result.categories).to eq(expected_result)
    end

    it "accepts scope" do
      old_categories = create_list(:category, 3, created_at: Time.zone.yesterday)
      create_list(:category, 3, created_at: Time.zone.tomorrow)

      result = described_class.result(scope: Category.where(created_at: ..Time.zone.today))

      expect(result.categories).to eq(old_categories)
    end
  end
end
