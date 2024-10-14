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
end
