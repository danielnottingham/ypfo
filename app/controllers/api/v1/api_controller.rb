# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      include Pundit::Authorization
      include Pagy::Backend
      include Respondable

      before_action :authenticate_devise_api_token!

      def current_user
        current_devise_api_user
      end

      rescue_from Pundit::NotAuthorizedError, with: :render_unauthorized
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

      def render_unauthorized(message = "Unauthorized")
        render json: { error: message }, status: :unauthorized
      end

      def render_not_found
        render json: { error: "Not found" }, status: :not_found
      end
    end
  end
end
