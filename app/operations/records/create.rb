# frozen_string_literal: true

module Records
  class Create < Actor
    input :params, type: Hash

    output :record, type: Record

    def call
      self.record = Record.new(params)

      ActiveRecord::Base.transaction do
        record.save!
        Accounts::UpdateBalance.call(id: record.account_id)
      rescue StandardError => e
        fail!(error: e.message)
      end
    end
  end
end
