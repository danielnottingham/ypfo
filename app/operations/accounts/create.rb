# frozen_string_literal: true

module Accounts
  class Create < Actor
    input :params, type: Hash

    output :account, type: Account

    def call
      self.account = Account.new(params)

      fail!(error: account.errors.full_messages) unless account.save
    end
  end
end
