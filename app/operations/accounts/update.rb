# frozen_string_literal: true

module Accounts
  class Update < Actor
    input :id, type: String
    input :params, type: Hash

    output :account, type: Account

    def call
      self.account = Account.find(id)

      fail!(error: account.errors.full_messages) unless account.update(params)
    end
  end
end
