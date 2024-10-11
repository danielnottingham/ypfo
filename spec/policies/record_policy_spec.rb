# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecordPolicy do
  describe "Scope" do
    it "returns all records for user" do
      user = create(:user)
      account = create(:account, user: user)
      records = create_list(:record, 3, account: account)

      scope = described_class::Scope.new(user, Record.all).resolve

      expect(scope).to eq records
    end

    it "returns no record for unregistered user" do
      account = create(:account)
      create_list(:record, 3, account: account)

      scope = described_class::Scope.new(nil, Record.all).resolve

      expect(scope).to eq []
    end
  end

  describe "#index?" do
    it "returns true for user" do
      user = create(:user)

      expect(described_class.new(user, Record).index?).to be true
    end

    it "returns false for unregistered user" do
      expect(described_class.new(nil, Record).index?).to be false
    end
  end

  describe "#create?" do
    it "returns true for user" do
      user = create(:user)

      expect(described_class.new(user, Record).create?).to be true
    end

    it "returns false for unregistered user" do
      expect(described_class.new(nil, Record).create?).to be false
    end
  end

  describe "#update?" do
    it "returns true for owner" do
      user = create(:user)
      account = create(:account, user: user)
      record = create(:record, account: account)

      expect(described_class.new(user, record).update?).to be true
    end

    it "returns false for non owner" do
      user = create(:user)
      record_owner = create(:user)
      account = create(:account, user: record_owner)
      record = create(:record, account: account)

      expect(described_class.new(user, record).update?).to be false
    end

    it "returns false for unregistered user" do
      expect(described_class.new(nil, Record).update?).to be false
    end
  end

  describe "#destroy?" do
    it "returns true for owner" do
      user = create(:user)
      account = create(:account, user: user)
      record = create(:record, account: account)

      expect(described_class.new(user, record).destroy?).to be true
    end

    it "returns false for non owner" do
      user = create(:user)
      record_owner = create(:user)
      account = create(:account, user: record_owner)
      record = create(:record, account: account)

      expect(described_class.new(user, record).destroy?).to be false
    end

    it "returns false for unregistered user" do
      expect(described_class.new(nil, Record).destroy?).to be false
    end
  end
end
