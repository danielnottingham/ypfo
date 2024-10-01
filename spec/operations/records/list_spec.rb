# frozen_string_literal: true

require "rails_helper"

RSpec.describe Records::List, type: :operation do
  describe ".result" do
    it "is successful" do
      create_list(:record, 3)

      result = described_class.result

      expect(result.success?).to be true
    end

    it "returns records ordered by occurred_in and created_at desc" do
      record_four = create(:record, occurred_in: Time.zone.yesterday)
      record_one = create(:record, occurred_in: Time.zone.today, created_at: Time.zone.yesterday)
      record_two = create(:record, occurred_in: Time.zone.today, created_at: Time.zone.today)
      record_three = create(:record, occurred_in: Time.zone.tomorrow)

      result = described_class.result

      expect(result.records).to eq([record_three, record_two, record_one, record_four])
    end

    it "accepts scope" do
      old_records = create_list(:record, 3, created_at: Time.zone.yesterday)
      create_list(:record, 3, created_at: Time.zone.tomorrow)

      result = described_class.result(scope: Record.where(created_at: ..Time.zone.today))

      expect(result.records.to_a).to match_array(old_records)
    end
  end
end
