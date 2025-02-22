# frozen_string_literal: true

require "rails_helper"

RSpec.describe CategoryPolicy do
  describe "Scope" do
    it "returns all records for user" do
      user = create(:user)
      categories = create_list(:category, 3, user: user)

      scope = described_class::Scope.new(user, Category.all).resolve

      expect(scope).to eq categories
    end

    it "returns no record for unregistered user" do
      create(:category)

      scope = described_class::Scope.new(nil, Category.all).resolve

      expect(scope).to eq []
    end
  end

  describe "#index?" do
    it "returns true for user" do
      user = create(:user)

      expect(described_class.new(user, Category).index?).to be true
    end

    it "returns false for unregistered user" do
      expect(described_class.new(nil, Category).index?).to be false
    end
  end

  describe "#create?" do
    it "returns true for user" do
      user = create(:user)

      expect(described_class.new(user, Category).index?).to be true
    end

    it "returns false for unregistered user" do
      expect(described_class.new(nil, Category).index?).to be false
    end
  end

  describe "#update?" do
    it "returns true for owner" do
      user = create(:user)
      category = create(:category, user: user)

      expect(described_class.new(user, category).update?).to be true
    end

    it "returns false for non owner" do
      user = create(:user)
      category = create(:category)

      expect(described_class.new(user, category).update?).to be false
    end

    it "returns false for unregistered user" do
      expect(described_class.new(nil, Category).update?).to be false
    end
  end

  describe "#destroy?" do
    it "returns true for owner" do
      user = create(:user)
      category = create(:category, user: user)

      expect(described_class.new(user, category).destroy?).to be true
    end

    it "returns false for non owner" do
      user = create(:user)
      category = create(:category)

      expect(described_class.new(user, category).destroy?).to be false
    end

    it "returns false for unregistered user" do
      expect(described_class.new(nil, Category).destroy?).to be false
    end
  end
end
