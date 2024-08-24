# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      include Pundit::Authorization

      before_action :authenticate_devise_api_token!
    end
  end
end
