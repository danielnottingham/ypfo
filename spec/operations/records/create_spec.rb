# frozen_string_literal: true

require "rails_helper"

RSpec.describe Records::Create, type: :operation do
  describe ".result" do
    context "with valid attributes" do
      it "is successful" do
        account = create(:account)
        record_attributes = attributes_for(:record, account: account)

        record = described_class.result(params: record_attributes)

        expect(record.success?).to be true
      end

      it "creates a new record" do
        result = nil
        account = create(:account)
        record_attributes = attributes_for(:record, account: account)

        expect do
          result = described_class.result(params: record_attributes)
        end.to change(Record, :count).by(1)

        expect(result.record.attributes).to include(
          {
            "title" => record_attributes[:title],
            "amount_cents" => record_attributes[:amount_cents],
            "amount_currency" => record_attributes[:amount_currency],
            "record_type" => record_attributes[:record_type],
            "payee" => record_attributes[:payee],
            "description" => record_attributes[:description],
            "account_id" => account.id
          }
        )
      end
    end

    context "with invalid attributes" do
      it "fails" do
        account = create(:account)
        record_attributes = attributes_for(:record, title: nil, account: account)

        result = described_class.result(params: record_attributes)

        expect(result).to be_failure
      end

      it "returns invalid record" do
        result = described_class.result(params: { title: nil })

        expect(result.record).to be_invalid
      end

      it "does not create a new record" do
        expect do
          described_class.result(params: { title: nil })
        end.not_to change(Record, :count)
      end
    end
  end
end
