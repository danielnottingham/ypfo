# frozen_string_literal: true

require "rails_helper"

RSpec.describe Records::Update, type: :operation do
  describe ".result" do
    it "is successful" do
      account = create(:account)
      record = create(:record, :income, account: account, title: "Record 1")

      result = described_class.result(id: record.id, params: { title: "Record 2" })

      expect(result).to be_success
    end

    it "updates the record" do
      record = create(:record, title: "Record 1")

      expect do
        described_class.result(id: record.id, params: { title: "Record 2" })
      end.to change { record.reload.title }.from("Record 1").to("Record 2")
    end

    context "when updates amount" do
      it "updates the account balance" do
        account = create(:account)
        record = create(:record, :income, account: account, amount_cents: 1000)

        result = described_class.result(id: record.id, params: { amount_cents: 2000 })

        expect(result.record.amount_cents).to eq(2000)
      end
    end

    context "when updates record type" do
      it "updates the account balance" do
        account = create(:account, balance_cents: -1000)
        record = create(:record, :expense, account: account, amount_cents: 3000)
        create(:record, :income, account: account, amount_cents: 2000)

        expect do
          described_class.result(id: record.id, params: { record_type: Records::Types::INCOME })
        end.to change { account.reload.balance_cents }.from(-1000).to(5000)
      end
    end

    context "when updates account id" do
      it "updates new and previous account balances" do
        account_a = create(:account, balance_cents: -1000)
        account_b = create(:account, balance_cents: 5000)

        record = create(:record, :expense, account: account_a, amount_cents: 3000)
        create(:record, :income, account: account_a, amount_cents: 2000)
        create(:record, :income, account: account_b, amount_cents: 5000)

        expect do
          described_class.result(id: record.id, params: { account_id: account_b.id })
        end.to change { account_a.reload.balance_cents }.from(-1000).to(2000)
          .and change { account_b.reload.balance_cents }.from(5000).to(2000)
      end
    end

    context "with invalid attributes" do
      it "fails" do
        record = create(:record, title: "Record 1")

        result = described_class.result(id: record.id, params: { title: nil })

        expect(result).to be_failure
      end

      it "returns invalid record" do
        record = create(:record, title: "Record 1")

        result = described_class.result(id: record.id, params: { title: nil })

        expect(result.record).not_to be_valid
      end
    end

    context "when account updates balance fails" do
      it "rollbacks record update" do
        record = create(:record, amount_cents: 1000)

        allow(Accounts::UpdateBalance).to receive(:call).with(id: record.account_id).and_raise("Some error")

        expect do
          described_class.result(id: record.id, params: { amount_cents: 2000 })
        end.not_to(change { record.reload.amount_cents })
      end
    end
  end
end
