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
end
