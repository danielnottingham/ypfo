# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Records" do
  describe "GET /api/v1/records" do
    context "when not authenticated" do
      it "returns unauthorized and error message" do
        get api_v1_records_path

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body["error_description"]).to eq([I18n.t("devise.api.error_response.invalid_token")])
      end
    end

    context "when authenticated" do
      context "when there are no records" do
        it "returns status :ok and empty array" do
          user = create(:user)
          token = access_token_for(user)

          get api_v1_records_path, headers: token

          expect(response).to have_http_status(:ok)
          expect(response.parsed_body["data"]).to include({ "records" => [] })
        end
      end

      context "when there are records" do
        it "returns status :ok with parsed_body message and status" do
          user = create(:user)
          token = access_token_for(user)
          account = create(:account, user: user)
          record_one = create(:record, account: account, title: "Record 1")
          record_two = create(:record, account: account, title: "Record 2")

          get api_v1_records_path, headers: token

          expect(response).to have_http_status(:ok)
          expect(response.parsed_body["message"]).to eq(I18n.t("activerecord.models.record.other"))
          expect(response.parsed_body["data"]).to include(
            { "records" => [
              {
                "id" => record_two.id,
                "title" => record_two.title,
                "amount_cents" => record_two.amount.format,
                "amount_currency" => record_two.amount_currency,
                "record_type" => record_two.record_type,
                "occurred_in" => record_two.occurred_in.strftime("%d/%m/%Y"),
                "payee" => record_two.payee,
                "description" => record_two.description,
                "account_id" => record_two.account_id
              },
              {
                "id" => record_one.id,
                "title" => record_one.title,
                "amount_cents" => record_one.amount.format,
                "amount_currency" => record_one.amount_currency,
                "record_type" => record_one.record_type,
                "occurred_in" => record_one.occurred_in.strftime("%d/%m/%Y"),
                "payee" => record_one.payee,
                "description" => record_one.description,
                "account_id" => record_one.account_id
              }
            ] }
          )
        end
      end
    end
  end

  describe "POST /api/v1/records" do
    context "when not authenticated" do
      it "returns unauthorized and error message" do
        post api_v1_records_path

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body["error_description"]).to eq([I18n.t("devise.api.error_response.invalid_token")])
      end
    end

    context "when authenticated" do
      context "when params are valid" do
        it "returns status :created with parsed_body message and status" do
          user = create(:user)
          account = create(:account, user: user)
          token = access_token_for(user)
          params = attributes_for(:record, account_id: account.id)

          post api_v1_records_path, headers: token, params: { record: params }

          expect(response).to have_http_status(:created)
          expect(response.parsed_body["message"]).to eq(I18n.t("api.v1.records.create.success"))
          expect(response.parsed_body["status"]).to eq("success")
        end

        it "returns parsed_body data" do
          user = create(:user)
          account = create(:account, user: user)
          token = access_token_for(user)
          params = attributes_for(:record, account_id: account.id)

          post api_v1_records_path, headers: token, params: { record: params }

          expect(response.parsed_body["data"]).to include(
            "record" => {
              "id" => anything,
              "title" => params[:title],
              "amount_cents" => Record.last.amount.format,
              "amount_currency" => params[:amount_currency],
              "record_type" => params[:record_type],
              "occurred_in" => params[:occurred_in].strftime("%d/%m/%Y"),
              "payee" => params[:payee],
              "description" => params[:description],
              "account_id" => account.id
            }
          )
        end
      end

      context "when params are invalid" do
        it "returns status :unprocessable_entity with parsed_body message and status" do
          user = create(:user)
          account = create(:account, user: user)
          token = access_token_for(user)
          params = attributes_for(:record, account_id: account.id, title: nil)

          post api_v1_records_path, headers: token, params: { record: params }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.parsed_body["message"]).to eq(I18n.t("api.v1.records.create.failure"))
          expect(response.parsed_body["status"]).to eq("error")
        end
      end
    end
  end
end
