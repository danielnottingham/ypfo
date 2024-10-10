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
          message_key: "activerecord.models.record.other",
          serializer: Api::V1::RecordSerializer,
          pagination: pagy_metadata(pagy)
        )
      end

      def create
        authorize(Record)
        result = Records::Create.result(params: record_params)

        if result.success?
          success_response(
            data: result.record,
            status: :created,
            message_key: "api.v1.records.create.success",
            serializer: Api::V1::RecordSerializer
          )
        else
          error_response(
            errors: result.error,
            status: :unprocessable_content,
            message_key: "api.v1.records.create.failure"
          )
        end
      end

      def update
        authorize(record)
        result = Records::Update.result(id: record.id.to_s, params: record_params)

        if result.success?
          success_response(
            data: result.record,
            serializer: Api::V1::RecordSerializer,
            status: :ok,
            message_key: "api.v1.records.update.success"
          )
        else
          error_response(
            errors: result.error,
            status: :unprocessable_content,
            message_key: "api.v1.records.update.failure"
          )
        end
      end

      private

      def record
        @record ||= Records::Find.result(id: params[:id]).record
      end

      def record_params
        params.require(:record).permit(
          :title,
          :amount_cents,
          :amount_currency,
          :record_type,
          :occurred_in,
          :payee,
          :description,
          :account_id
        ).to_h
      end
    end
  end
end
