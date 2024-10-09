# frozen_string_literal: true

require "rails_helper"

RSpec.describe Records::Find, type: :operation do
  describe ".result" do
    it "is successful" do
      record = create(:record)

      result = described_class.result(id: record.id)

      expect(result).to be_success
    end

    it "returns the record" do
      record = create(:record)

      result = described_class.result(id: record.id)

      expect(result.record).to eq(record)
    end

    context "when record with given id does not exist" do
      it "raises ActiveRecord::RecordNotFound error" do
        expect { described_class.result(id: "invalid-id") }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
