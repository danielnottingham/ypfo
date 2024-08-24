# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Accounts" do
  describe "GET /api/v1/accounts" do
    context "when not authenticated" do
      it "returns unauthorized" do
        get api_v1_accounts_path
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns error message" do
        get api_v1_accounts_path
        expect(response.parsed_body["error_description"]).to eq([I18n.t("devise.api.error_response.invalid_token")])
      end
    end

    context "when authenticated" do
      context "when there are no accounts" do
        it "returns status :ok" do
          user = create(:user)
          token = access_token_for(user)

          get api_v1_accounts_path, headers: token

          expect(response).to have_http_status(:ok)
        end

        it "returns an empty array" do
          user = create(:user)
          token = access_token_for(user)

          get api_v1_accounts_path, headers: token

          expect(response.parsed_body).to eq([])
        end
      end

      context "when there are accounts" do
        it "returns status :ok" do
          user = create(:user)
          token = access_token_for(user)

          get api_v1_accounts_path, headers: token

          expect(response).to have_http_status(:ok)
        end

        it "returns an array of accounts" do
          user = create(:user)
          token = access_token_for(user)
          account_one = create(:account, user: user, title: "Account 1")
          account_two = create(:account, user: user, title: "Account 2")

          get api_v1_accounts_path, headers: token

          expect(response.parsed_body.count).to eq(2)
          expect(response.parsed_body).to include(
            {
              "id" => account_one.id,
              "title" => account_one.title,
              "balance_cents" => account_one.balance_cents,
              "balance_currency" => account_one.balance_currency,
              "color" => account_one.color,
              "user_id" => account_one.user_id
            },
            {
              "id" => account_two.id,
              "title" => account_two.title,
              "balance_cents" => account_two.balance_cents,
              "balance_currency" => account_two.balance_currency,
              "color" => account_two.color,
              "user_id" => account_two.user_id
            }
          )
        end
      end
    end
  end
end
