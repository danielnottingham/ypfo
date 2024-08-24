# frozen_string_literal: true

module Api
  module V1
    class AccountsController < ApiController
      def index
        accounts = Account.where(user: current_devise_api_user)

        render json: accounts, each_serializer: Api::V1::AccountSerializer, status: :ok
      end
    end
  end
end
