# frozen_string_literal: true

require "rails_helper"

RSpec.describe Accounts::List, type: :operation do
  describe ".result" do
    it "is successful" do
      result = described_class.result(scope: Account.all)

      expect(result.success?).to be true
    end

    it "returns accounts ordered by created_at desc" do
      user = create(:user)
      yesterday_account = create(:account, user: user, created_at: Time.zone.yesterday)
      tomorrow_account = create(:account, user: user, created_at: Time.zone.tomorrow)
      today_account = create(:account, user: user, created_at: Time.zone.today)

      result = described_class.result(scope: Account.all)

      expect(result.accounts).to eq([tomorrow_account, today_account, yesterday_account])
    end
  end
end
