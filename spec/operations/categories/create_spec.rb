# frozen_string_literal: true

require "rails_helper"

RSpec.describe Categories::Create, type: :operation do
  describe ".result" do
    context "with valid params" do
      it "is successful" do
        user = create(:user)
        attributes = attributes_for(:category)
        params = attributes.merge(user: user)

        result = described_class.result(params: params)

        expect(result).to be_success
      end

      it "creates a new category" do
        result = nil
        user = create(:user)
        attributes = attributes_for(:category)
        params = attributes.merge(user: user)

        expect do
          result = described_class.result(params: params)
        end.to change(Category, :count).by(1)

        expect(result.category.attributes).to include(
          {
            "user_id" => user.id, "title" => attributes[:title], "color" => attributes[:color]
          }
        )
      end
    end

    context "with invalid params" do
      it "fails" do
        user = create(:user)
        attributes = attributes_for(:category, title: nil)
        params = attributes.merge(user: user)

        result = described_class.result(params: params)

        expect(result).to be_failure
      end

      it "return invalid category" do
        user = create(:user)
        attributes = attributes_for(:category, title: nil)
        params = attributes.merge(user: user)

        result = described_class.result(params: params)

        expect(result.category).to be_invalid
      end

      it "does not create a new category" do
        user = create(:user)
        attributes = attributes_for(:category, title: nil)
        params = attributes.merge(user: user)

        expect do
          described_class.result(params: params)
        end.not_to change(Category, :count)
      end
    end
  end
end
