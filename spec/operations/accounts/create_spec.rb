# frozen_string_literal: true

require "rails_helper"

RSpec.describe Accounts::Create, type: :operation do
  describe ".result" do
    context "with valid attributes" do
      it "is successful" do
        user = create(:user)
        attributes = attributes_for(:account)
        params = attributes.merge(user: user)

        result = described_class.result(params: params)

        expect(result.success?).to be true
      end

      it "creates a new account" do
        result = nil
        user = create(:user)
        attributes = attributes_for(:account, title: "My account", color: "#ffffff")
        params = attributes.merge(user: user)

        expect do
          result = described_class.result(params: params)
        end.to change(Account, :count).by(1)

        expect(result.account.attributes).to include(
          {
            "user_id" => user.id, "title" => "My account", "color" => "#ffffff"
          }
        )
      end
    end

    context "with invalid attributes" do
      it "is failure" do
        result = described_class.result(params: { title: nil })

        expect(result).to be_failure
      end

      it "returns invalid account" do
        result = described_class.result(params: { title: nil })

        expect(result.account).to be_invalid
      end

      it "does not create a new account" do
        expect do
          described_class.result(params: { title: nil })
        end.not_to change(Account, :count)
      end
    end
  end
end
