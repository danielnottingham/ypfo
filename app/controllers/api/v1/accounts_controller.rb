# frozen_string_literal: true

module Api
  module V1
    class AccountsController < ApiController
      def index
        authorized_scope = policy_scope(Account)
        result = Accounts::List.result(scope: authorized_scope)
        pagy, accounts = pagy(result.accounts)

        render json: { accounts: serialized_accounts(accounts), pagination: pagy_metadata(pagy) }, status: :ok
      end

      private

      def serialized_accounts(accounts)
        ActiveModelSerializers::SerializableResource.new(accounts, each_serializer: Api::V1::AccountSerializer)
      end
    end
  end
end
