# frozen_string_literal: true

module Api
  module V1
    class AccountsController < ApiController
      def index
        authorized_scope = policy_scope(Account)
        result = Accounts::List.result(scope: authorized_scope)
        pagy, accounts = pagy(result.accounts)

        success_response(
          data: accounts,
          serializer: Api::V1::AccountSerializer,
          message: I18n.t("activerecord.models.account.other"),
          pagination: pagy_metadata(pagy)
        )
      end

      def create
        authorize(Account)
        result = Accounts::Create.result(params: account_params)

        if result.success?
          success_response(
            data: result.account,
            serializer: Api::V1::AccountSerializer,
            status: :created,
            message: I18n.t("api.v1.accounts.create.success")
          )
        else
          error_response(
            errors: result.error,
            status: :unprocessable_content,
            message: I18n.t("api.v1.accounts.create.failure")
          )
        end
      end

      def update
        authorize(account)
        result = Accounts::Update.result(id: account.id.to_s, params: account_params)

        if result.success?
          success_response(
            data: result.account,
            serializer: Api::V1::AccountSerializer,
            status: :ok,
            message: I18n.t("api.v1.accounts.update.success")
          )
        else
          error_response(
            errors: result.error,
            status: :unprocessable_content,
            message: I18n.t("api.v1.accounts.update.failure")
          )
        end
      end

      private

      def account
        @account ||= Accounts::Find.result(id: params[:id]).account
      end

      def account_params
        params.require(:account).permit(:title, :color).to_h.merge(user: current_user)
      end
    end
  end
end
