# frozen_string_literal: true

require "rails_helper"

RSpec.describe Accounts::Find, type: :operation do
  describe ".result" do
    context "when account with given id exists" do
      it "is successful" do
        user = create(:user)
        account = create(:account, user: user)

        result = described_class.result(id: account.id)

        expect(result.success?).to be true
      end

      it "returns the account" do
        user = create(:user)
        account = create(:account, user: user)

        result = described_class.result(id: account.id)

        expect(result.account).to eq(account)
      end
    end

    context "when account with given id does not exist" do
      it "raises ActiveRecord::RecordNotFound error" do
        expect { described_class.result(id: "invalid-id") }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
