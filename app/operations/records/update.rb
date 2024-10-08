# frozen_string_literal: true

module Records
  class Update < Actor
    input :id, type: String
    input :params, type: Hash

    output :record, type: Record

    def call
      self.record = Record.find(id)

      ActiveRecord::Base.transaction do
        record.update!(params)
        update_account_balance if update_account_balance?
      rescue StandardError => e
        fail!(error: e.message)
      end
    end

    private

    def update_account_balance
      Accounts::UpdateBalance.call(id: record.account_id)

      return unless record.account_id_previously_changed?

      Accounts::UpdateBalance.call(id: record.account_id_previously_was)
    end

    def update_account_balance?
      record.saved_change_to_amount_cents? || record.saved_change_to_record_type? || record.saved_change_to_account_id?
    end
  end
end
