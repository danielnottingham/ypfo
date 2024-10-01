# frozen_string_literal: true

module Api
  module V1
    class RecordSerializer < ActiveModel::Serializer
      attributes :id, :title, :amount_cents, :amount_currency, :record_type, :occurred_in, :payee, :description,
        :account_id

      def amount_cents
        object.amount.format
      end

      def occurred_in
        object.occurred_in.strftime("%d/%m/%Y")
      end
    end
  end
end
