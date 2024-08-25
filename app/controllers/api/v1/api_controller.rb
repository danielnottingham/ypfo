# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      include Pundit::Authorization
      include Pagy::Backend

      before_action :authenticate_devise_api_token!

      def current_user
        current_devise_api_user
      end
    end
  end
end
