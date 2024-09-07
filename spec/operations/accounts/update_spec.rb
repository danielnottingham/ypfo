# frozen_string_literal: true

require "rails_helper"

RSpec.describe Accounts::Update, type: :operation do
  describe ".result" do
    context "with valid attributes" do
      it "is successful" do
        user = create(:user)
        account = create(:account, user: user)
        params = { id: account.id, title: "Updated Account Title", color: "#ffffff" }

        result = described_class.result(id: params[:id], params: params)

        expect(result).to be_success
      end

      it "updates the account" do
        user = create(:user)
        account = create(:account, user: user)
        params = { id: account.id, title: "Updated Account Title", color: "#ffffff" }

        result = described_class.result(id: params[:id], params: params)

        expect(result.account.title).to eq("Updated Account Title")
      end
    end

    context "with invalid attributes" do
      it "fails" do
        user = create(:user)
        account = create(:account, user: user)
        params = { id: account.id, title: nil, color: "#ffffff" }

        result = described_class.result(id: params[:id], params: params)

        expect(result).to be_failure
      end

      it "returns invalid account" do
        user = create(:user)
        account = create(:account, user: user)
        params = { id: account.id, title: nil, color: "#ffffff" }

        result = described_class.result(id: params[:id], params: params)

        expect(result.account).to be_invalid
      end
    end

    context "when account with given id does not exist" do
      it "raises ActiveRecord::RecordNotFound error" do
        expect { described_class.result(id: "invalid-id", params: {}) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
