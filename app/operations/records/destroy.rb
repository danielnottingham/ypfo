# frozen_string_literal: true

module Records
  class Destroy < Actor
    input :id, type: String

    output :record, type: Record

    def call
      self.record = Record.find(id)

      ActiveRecord::Base.transaction do
        record.destroy!
        Accounts::UpdateBalance.call(id: record.account_id)
      rescue StandardError => e
        fail!(error: e.message)
      end
    end
  end
end
