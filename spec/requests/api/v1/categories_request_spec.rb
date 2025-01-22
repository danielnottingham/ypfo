# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Categories" do
  describe "GET /api/v1/categories" do
    context "when not authenticated" do
      it "returns unauthorized and error message" do
        get api_v1_categories_path

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body["error_description"]).to eq([I18n.t("devise.api.error_response.invalid_token")])
      end
    end

    context "when authenticated" do
      context "when there are no categories" do
        it "returns status :ok and empty array" do
          user = create(:user)
          token = access_token_for(user)

          get api_v1_categories_path, headers: token

          expect(response).to have_http_status(:ok)
          expect(response.parsed_body["data"]).to include({ "categories" => [] })
        end
      end

      context "when there are categories" do
        it "returns status :ok with parsed_body message and status" do
          user = create(:user)
          token = access_token_for(user)
          categorie_one = create(:category, user: user, title: "Category 1")
          categorie_two = create(:category, user: user, title: "Category 2")

          get api_v1_categories_path, headers: token

          expect(response).to have_http_status(:ok)
          expect(response.parsed_body["message"]).to eq(I18n.t("activerecord.models.category.other"))
          expect(response.parsed_body["data"]).to include(
            {
              "categories" => [
                {
                  "id" => anything,
                  "title" => categorie_two.title,
                  "color" => categorie_two.color,
                  "user_id" => user.id
                },
                {
                  "id" => anything,
                  "title" => categorie_one.title,
                  "color" => categorie_one.color,
                  "user_id" => user.id
                }
              ]
            }
          )
        end
      end
    end
  end

  describe "POST /api/v1/categories" do
    context "when not authenticated" do
      it "returns unauthorized and error message" do
        post api_v1_categories_path

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body["error_description"]).to eq([I18n.t("devise.api.error_response.invalid_token")])
      end
    end

    context "when authenticated" do
      context "when params are valid" do
        it "returns status :created with parsed_body message and status" do
          user = create(:user)
          token = access_token_for(user)
          attributes = attributes_for(:category)
          params = attributes.merge(user: user)

          post api_v1_categories_path, headers: token, params: { category: params }

          expect(response).to have_http_status(:created)
          expect(response.parsed_body["message"]).to eq(I18n.t("api.v1.categories.create.success"))
          expect(response.parsed_body["status"]).to eq("success")
        end

        it "returns parsed_body data" do
          user = create(:user)
          token = access_token_for(user)
          attributes = attributes_for(:category, title: "Category 1", color: "#ffffff")
          params = attributes.merge(user: user)

          post api_v1_categories_path, headers: token, params: { category: params }

          expect(response.parsed_body["data"]).to include(
            "category" => {
              "id" => anything,
              "title" => "Category 1",
              "color" => "#ffffff",
              "user_id" => user.id
            }
          )
        end
      end

      context "when params are invalid" do
        it "returns status :unprocessable_entity with parsed_body message and status" do
          user = create(:user)
          token = access_token_for(user)
          params = attributes_for(:category, title: nil)

          post api_v1_categories_path, headers: token, params: { category: params }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.parsed_body["message"]).to eq(I18n.t("api.v1.categories.create.failure"))
          expect(response.parsed_body["status"]).to eq("error")
        end
      end
    end
  end

  describe "PATCH PUT /api/v1/categories/:id" do
    context "when not authenticated" do
      it "returns unauthorized and error message" do
        category = create(:category)

        patch api_v1_category_path(category)

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body["error_description"]).to eq([I18n.t("devise.api.error_response.invalid_token")])
      end
    end

    context "when authenticated" do
      context "when params are valid" do
        it "returns status :ok with parsed_body message and status" do
          user = create(:user)
          token = access_token_for(user)
          category = create(:category, user: user)
          attributes = attributes_for(:category, title: "Category 1", color: "#ffffff")
          params = attributes.merge(user: user)

          patch api_v1_category_path(category), headers: token, params: { category: params }

          expect(response).to have_http_status(:ok)
          expect(response.parsed_body["message"]).to eq(I18n.t("api.v1.categories.update.success"))
          expect(response.parsed_body["status"]).to eq("success")
        end

        it "returns parsed_body data" do
          user = create(:user)
          token = access_token_for(user)
          category = create(:category, user: user)
          attributes = attributes_for(:category, title: "Category 1", color: "#ffffff")
          params = attributes.merge(user: user)

          patch api_v1_category_path(category), headers: token, params: { category: params }

          expect(response.parsed_body["data"]).to include(
            "category" => {
              "id" => category.id,
              "title" => "Category 1",
              "color" => "#ffffff",
              "user_id" => user.id
            }
          )
        end
      end

      context "when params are invalid" do
        it "returns status :unprocessable_entity with parsed_body message and status" do
          user = create(:user)
          token = access_token_for(user)
          category = create(:category, user: user)
          params = attributes_for(:category, title: nil)

          patch api_v1_category_path(category), headers: token, params: { category: params }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.parsed_body["message"]).to eq(I18n.t("api.v1.categories.update.failure"))
          expect(response.parsed_body["status"]).to eq("error")
        end
      end
    end
  end

  describe "DELETE /api/v1/categories/:id" do
    context "when not authenticated" do
      it "returns unauthorized and error message" do
        category = create(:category)

        delete api_v1_category_path(category)

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body["error_description"]).to eq([I18n.t("devise.api.error_response.invalid_token")])
      end
    end

    context "when authenticated" do
      it "returns status :ok with parsed_body message and status" do
        user = create(:user)
        token = access_token_for(user)
        category = create(:category, user: user)

        delete api_v1_category_path(category), headers: token

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body["message"]).to eq(I18n.t("api.v1.categories.destroy.success"))
        expect(response.parsed_body["status"]).to eq("success")
      end

      context "when category cannot be destroyed" do
        it "returns status :unprocessable_entity with parsed_body message and status" do
          user = create(:user)
          category = create(:category, user: user)
          token = access_token_for(user)
          allow(Category).to receive(:find).with(category.id.to_s).and_return(category)
          allow(category).to receive(:destroy).and_return(false)

          delete api_v1_category_path(category.id), headers: token

          expect(response).to have_http_status(:unprocessable_content)
          expect(response.parsed_body["message"]).to eq(I18n.t("api.v1.categories.destroy.failure"))
          expect(response.parsed_body["status"]).to eq("error")
        end
      end
    end
  end
end
