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

        it "returns errors" do
          user = create(:user)
          account = create(:account, user: user)
          token = access_token_for(user)
          params = attributes_for(:record, account_id: account.id, title: nil, occurred_in: nil)

          post api_v1_records_path, headers: token, params: { record: params }

          expect(response.parsed_body["errors"]).to eq(
            "A validação falhou: Título não pode ficar em branco, Data não pode ficar em branco"
          )
        end
      end
    end
  end

  describe "PATCH /api/v1/records/:id" do
    context "when not authenticated" do
      it "returns unauthorized and error message" do
        record = create(:record)

        patch api_v1_record_path(record)

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body["error_description"]).to eq([I18n.t("devise.api.error_response.invalid_token")])
      end
    end

    context "when authenticated" do
      context "when params are valid" do
        it "returns status :ok with parsed_body message and status" do
          user = create(:user)
          account = create(:account, user: user)
          record = create(:record, account: account)
          params = { title: "Updated Record Title" }

          patch api_v1_record_path(record), headers: access_token_for(user), params: { record: params }

          expect(response).to have_http_status(:ok)
          expect(response.parsed_body["message"]).to eq(I18n.t("api.v1.records.update.success"))
          expect(response.parsed_body["status"]).to eq("success")
        end

        it "returns parsed_body data" do
          user = create(:user)
          account = create(:account, user: user)
          record = create(:record, account: account, title: "Record 1")
          params = { title: "Updated Record Title" }

          patch api_v1_record_path(record), headers: access_token_for(user), params: { record: params }

          expect(response.parsed_body["data"]).to include(
            "record" => {
              "id" => record.id,
              "title" => params[:title],
              "amount_cents" => Record.last.amount.format,
              "amount_currency" => Record.last.amount.currency,
              "record_type" => Record.last.record_type,
              "occurred_in" => Record.last.occurred_in.strftime("%d/%m/%Y"),
              "payee" => Record.last.payee,
              "description" => Record.last.description,
              "account_id" => account.id
            }
          )
        end
      end

      context "when params are invalid" do
        it "returns status :unprocessable_entity with parsed_body message and status" do
          user = create(:user)
          account = create(:account, user: user)
          record = create(:record, account: account)
          params = { title: nil }

          patch api_v1_record_path(record), headers: access_token_for(user), params: { record: params }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.parsed_body["message"]).to eq(I18n.t("api.v1.records.update.failure"))
          expect(response.parsed_body["status"]).to eq("error")
          expect(response.parsed_body["errors"]).to eq("A validação falhou: Título não pode ficar em branco")
        end
      end
    end
  end

  describe "DELETE /api/v1/records/:id" do
    context "when not authenticated" do
      it "returns unauthorized and error message" do
        record = create(:record)

        delete api_v1_record_path(record)

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body["error_description"]).to eq([I18n.t("devise.api.error_response.invalid_token")])
      end
    end

    context "when authenticated" do
      context "when record exists and can be deleted" do
        it "returns status :ok with parsed_body message and status" do
          user = create(:user)
          account = create(:account, user: user)
          record = create(:record, account: account)
          token = access_token_for(user)

          delete api_v1_record_path(record), headers: token

          expect(response).to have_http_status(:ok)
          expect(response.parsed_body["message"]).to eq(I18n.t("api.v1.records.destroy.success"))
          expect(response.parsed_body["status"]).to eq("success")
        end
      end

      context "when does not find the record" do
        it "returns status :not_found and error message" do
          user = create(:user)
          token = access_token_for(user)
          delete api_v1_record_path("fake-id"), headers: token

          expect(response).to have_http_status(:not_found)
          expect(response.parsed_body["error"]).to eq("Not found")
        end
      end

      context "when record does not belong to user" do
        it "returns status unauthorized with parsed_body error message" do
          user = create(:user)
          another_user = create(:user)
          account = create(:account, user: user)
          record = create(:record, account: account)
          token = access_token_for(another_user)

          delete api_v1_record_path(record), headers: token

          expect(response).to have_http_status(:unauthorized)
          expect(response.parsed_body["error"]).to eq("not allowed to RecordPolicy#destroy? this Record")
        end
      end

      context "when record cannot be destroyed" do
        it "returns status :unprocessable_content with parsed_body message and status" do
          user = create(:user)
          account = create(:account, user: user)
          record = create(:record, account: account)
          token = access_token_for(user)
          allow(Record).to receive(:find).with(record.id.to_s).and_return(record)
          allow(record).to receive(:destroy).and_return(false)

          delete api_v1_record_path(record), headers: token

          expect(response).to have_http_status(:unprocessable_content)
          expect(response.parsed_body["message"]).to eq(I18n.t("api.v1.records.destroy.failure"))
          expect(response.parsed_body["status"]).to eq("error")
        end
      end
    end
  end
end
