# frozen_string_literal: true

module Api
  module V1
    class RecordsController < ApiController
      def index
        authorized_scope = policy_scope(Record)
        result = Records::List.result(scope: authorized_scope)
        pagy, records = pagy(result.records)

        success_response(
          data: records,
          message: I18n.t("activerecord.models.record.other"),
          serializer: Api::V1::RecordSerializer,
          pagination: pagy_metadata(pagy)
        )
      end
    end
  end
end
