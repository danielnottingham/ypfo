# frozen_string_literal: true

require "rails_helper"

RSpec.describe Categories::Update, type: :operation do
  describe ".result" do
    context "when category with given id exists" do
      context "with valid params" do
        it "is successful" do
          category = create(:category)

          result = described_class.result(id: category.id, params: { title: "New title" })

          expect(result).to be_success
        end

        it "updates the category" do
          category = create(:category)

          result = described_class.result(id: category.id, params: { title: "New title" })

          expect(result.category.title).to eq("New title")
        end
      end

      context "with invalid params" do
        it "fails" do
          category = create(:category)

          result = described_class.result(id: category.id, params: { title: nil })

          expect(result).to be_failure
        end

        it "returns invalid category" do
          category = create(:category)

          result = described_class.result(id: category.id, params: { title: nil })

          expect(result.category).to be_invalid
        end

        it "does not update the category" do
          category = create(:category)

          expect do
            described_class.result(id: category.id, params: { title: nil })
          end.not_to(change { category.reload.title })
        end
      end
    end

    context "when category with given id does not exist" do
      it "raises ActiveRecord::RecordNotFound error" do
        expect { described_class.result(id: "invalid-id", params: {}) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
