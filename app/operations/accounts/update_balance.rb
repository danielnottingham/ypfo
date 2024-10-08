# frozen_string_literal: true

module Accounts
  class UpdateBalance < Actor
    input :id, type: String

    def call
      account = Account.find(id)
      balance_cents = Record.where(account_id: account.id).sum("records.amount_cents * records.record_type")

      fail!(error: account.errors.full_messages) unless account.update(balance_cents: balance_cents)
    end
  end
end
