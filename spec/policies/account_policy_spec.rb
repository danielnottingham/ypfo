# frozen_string_literal: true

require "rails_helper"

RSpec.describe AccountPolicy do
  describe "Scope" do
    it "returns all accounts for user" do
      user = create(:user)
      accounts = create_list(:account, 3, user: user)

      scope = described_class::Scope.new(user, Account.all).resolve

      expect(scope).to eq accounts
    end

    it "returns no account for unregistered user" do
      create(:account)
      scope = described_class::Scope.new(nil, Account.all).resolve

      expect(scope).to eq []
    end
  end

  describe "#index?" do
    it "returns true for user" do
      user = create(:user)

      expect(described_class.new(user, Account).index?).to be true
    end

    it "returns false for unregistered user" do
      expect(described_class.new(nil, Account).index?).to be false
    end
  end

  describe "#create?" do
    it "returns true for user" do
      user = create(:user)

      expect(described_class.new(user, Account).create?).to be true
    end

    it "returns false for unregistered user" do
      expect(described_class.new(nil, Account).create?).to be false
    end
  end

  describe "#update?" do
    it "returns true for user" do
      user = create(:user)
      account = create(:account, user: user)

      expect(described_class.new(user, account).update?).to be true
    end

    it "returns false for non-owner" do
      account = create(:account)

      expect(described_class.new(nil, account).update?).to be false
    end
  end
end
