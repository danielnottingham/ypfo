# frozen_string_literal: true

require "rails_helper"

RSpec.describe Accounts::UpdateBalance, type: :operation do
  describe ".result" do
    it "is successful" do
      account = create(:account, balance_cents: 1000)
      record = create(:record, :income, account: account, amount_cents: 2500)

      result = described_class.result(id: record.account_id)

      expect(result).to be_success
    end

    it "updates the account balance" do
      account = create(:account)
      create(:record, :income, account: account, amount_cents: 3000)
      create(:record, :income, account: account, amount_cents: 1000)
      create(:record, :expense, account: account, amount_cents: 6000)
      create(:record, :expense, amount_cents: 5000)

      expect { described_class.result(id: account.id) }.to change { account.reload.balance_cents }.from(0).to(-2000)
    end

    context "when updating balance fails" do
      it "fails" do
        account = create(:account)

        allow(Account).to receive(:find).with(account.id).and_return(account)
        allow(account).to receive(:update).and_return(false)

        result = described_class.result(id: account.id)

        expect(result).to be_failure
      end
    end

    context "when account with given id does not exist" do
      it "raises ActiveRecord::RecordNotFound error" do
        expect { described_class.result(id: "invalid-id") }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
