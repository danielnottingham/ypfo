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

          expect(response.parsed_body[:data]).to include({ "accounts" => [] })
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

          expect(response.parsed_body[:data][:accounts].count).to eq(2)
          expect(response.parsed_body[:pagination]).to be_present
          expect(response.parsed_body[:data][:accounts]).to match_array(
            [
              {
                "id" => account_one.id,
                "title" => account_one.title,
                "balance_cents" => account_one.balance.format,
                "balance_currency" => account_one.balance_currency,
                "color" => account_one.color,
                "user_id" => account_one.user_id
              },
              {
                "id" => account_two.id,
                "title" => account_two.title,
                "balance_cents" => account_two.balance.format,
                "balance_currency" => account_two.balance_currency,
                "color" => account_two.color,
                "user_id" => account_two.user_id
              }
            ]
          )
        end
      end
    end
  end

  describe "POST /api/v1/accounts" do
    context "when not authenticated" do
      it "returns unauthorized" do
        post api_v1_accounts_path

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when authenticated" do
      context "when params are valid" do
        it "returns status :created with parsed_body message and status" do
          user = create(:user)
          token = access_token_for(user)
          attributes = attributes_for(:account)
          params = attributes.merge(user: user)

          post api_v1_accounts_path, headers: token, params: { account: params }

          expect(response).to have_http_status(:created)
          expect(response.parsed_body["message"]).to eq(I18n.t("api.v1.accounts.create.success"))
          expect(response.parsed_body["status"]).to eq("success")
        end

        it "returns parsed_body data" do
          user = create(:user)
          token = access_token_for(user)
          attributes = attributes_for(:account, title: "Account 1", color: "#ffffff")
          params = attributes.merge(user: user)

          post api_v1_accounts_path, headers: token, params: { account: params }

          expect(response.parsed_body["data"]["account"]["title"]).to eq(params[:title])
          expect(response.parsed_body["data"]["account"]["color"]).to eq(params[:color])
        end
      end

      context "when params are invalid" do
        it "returns status :unprocessable_content with parsed_body message and status" do
          user = create(:user)
          token = access_token_for(user)
          attributes = { title: nil, color: "#ffffff" }
          params = attributes.merge(user: user)

          post api_v1_accounts_path, headers: token, params: { account: params }

          expect(response).to have_http_status(:unprocessable_content)
          expect(response.parsed_body["message"]).to eq(I18n.t("api.v1.accounts.create.failure"))
          expect(response.parsed_body["status"]).to eq("error")
        end
      end
    end
  end

  describe "PATCH /api/v1/accounts/:id" do
    context "when not authenticated" do
      it "returns unauthorized" do
        account = create(:account)

        patch api_v1_account_path(account.id)

        expect(response).to have_http_status(:unauthorized)
      end

      it "returns error message" do
        account = create(:account)

        patch api_v1_account_path(account.id)

        expect(response.parsed_body["error_description"]).to eq([I18n.t("devise.api.error_response.invalid_token")])
      end
    end

    context "when authenticated" do
      context "with valid params" do
        it "returns status :ok with parsed_body message and status" do
          user = create(:user)
          account = create(:account, user: user)
          token = access_token_for(user)
          params = { id: account.id, title: "Updated Account Title", color: "#ffffff" }

          patch api_v1_account_path(account.id), headers: token, params: { account: params }

          expect(response).to have_http_status(:ok)
          expect(response.parsed_body["message"]).to eq(I18n.t("api.v1.accounts.update.success"))
          expect(response.parsed_body["status"]).to eq("success")
        end

        it "returns parsed_body data" do
          user = create(:user)
          account = create(:account, user: user)
          token = access_token_for(user)
          params = { id: account.id, title: "Updated Account Title", color: "#ffffff" }

          patch api_v1_account_path(account.id), headers: token, params: { account: params }

          expect(response.parsed_body["data"]["account"]["id"]).to eq(account.id)
          expect(response.parsed_body["data"]["account"]["title"]).to eq(params[:title])
          expect(response.parsed_body["data"]["account"]["color"]).to eq(params[:color])
          expect(response.parsed_body["data"]["account"]["user_id"]).to eq(user.id)
        end
      end

      context "with invalid params" do
        it "returns status :unprocessable_content with parsed_body message and status" do
          user = create(:user)
          account = create(:account, user: user)
          token = access_token_for(user)
          params = { id: account.id, title: nil, color: "#ffffff" }

          patch api_v1_account_path(account.id), headers: token, params: { account: params }

          expect(response).to have_http_status(:unprocessable_content)
          expect(response.parsed_body["message"]).to eq(I18n.t("api.v1.accounts.update.failure"))
          expect(response.parsed_body["status"]).to eq("error")
        end
      end
    end
  end

  describe "DELETE /api/v1/accounts/:id" do
    context "when not authenticated" do
      it "returns unauthorized" do
        account = create(:account)

        delete api_v1_account_path(account.id)

        expect(response).to have_http_status(:unauthorized)
      end

      it "returns error message" do
        account = create(:account)

        delete api_v1_account_path(account.id)

        expect(response.parsed_body["error_description"]).to eq([I18n.t("devise.api.error_response.invalid_token")])
      end
    end

    context "when authenticated" do
      it "returns status :ok with parsed_body message and status" do
        user = create(:user)
        account = create(:account, user: user)
        token = access_token_for(user)

        delete api_v1_account_path(account.id), headers: token

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body["message"]).to eq(I18n.t("api.v1.accounts.destroy.success"))
        expect(response.parsed_body["status"]).to eq("success")
      end

      context "when account cannot be destroyed" do
        it "returns status :unprocessable_content with parsed_body message and status" do
          user = create(:user)
          account = create(:account, user: user)
          token = access_token_for(user)
          allow(Account).to receive(:find).with(account.id.to_s).and_return(account)
          allow(account).to receive(:destroy).and_return(false)

          delete api_v1_account_path(account.id), headers: token

          expect(response).to have_http_status(:unprocessable_content)
          expect(response.parsed_body["message"]).to eq(I18n.t("api.v1.accounts.destroy.failure"))
          expect(response.parsed_body["status"]).to eq("error")
        end
      end

      context "when does not find account" do
        it "returns status :not_found and error message" do
          user = create(:user)
          token = access_token_for(user)
          delete api_v1_account_path("fake-id"), headers: token

          expect(response).to have_http_status(:not_found)
          expect(response.parsed_body["error"]).to eq("Not found")
        end
      end

      context "when account does not belong to user" do
        it "returns status :unauthorized and error message" do
          user = create(:user)
          account = create(:account)
          token = access_token_for(user)

          delete api_v1_account_path(account.id), headers: token

          expect(response).to have_http_status(:unauthorized)
          expect(response.parsed_body["error"]).to eq("not allowed to AccountPolicy#destroy? this Account")
        end
      end
    end
  end
end
