# frozen_string_literal: true

module Api
  module V1
    class CategoriesController < ApiController
      def index
        authorized_scope = policy_scope(Category)
        result = Categories::List.result(scope: authorized_scope)
        pagy, categories = pagy(result.categories)

        success_response(
          data: categories,
          serializer: Api::V1::CategorySerializer,
          message_key: "activerecord.models.category.other",
          pagination: pagy_metadata(pagy)
        )
      end
    end
  end
end
