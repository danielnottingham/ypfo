# frozen_string_literal: true

module Records
  class Create < Actor
    input :params, type: Hash

    output :record, type: Record

    def call
      self.record = Record.new(params)

      fail!(error: record.errors.full_messages) unless record.save
    end
  end
end
