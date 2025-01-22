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

      def create
        authorize(Category)
        result = Categories::Create.result(params: category_params)

        if result.success?
          success_response(
            data: result.category,
            serializer: Api::V1::CategorySerializer,
            status: :created,
            message_key: "api.v1.categories.create.success"
          )
        else
          error_response(
            errors: result.error,
            status: :unprocessable_content,
            message_key: "api.v1.categories.create.failure"
          )
        end
      end

      def update
        authorize(category)
        result = Categories::Update.result(id: category.id, params: category_params)

        if result.success?
          success_response(
            data: result.category,
            serializer: Api::V1::CategorySerializer,
            status: :ok,
            message_key: "api.v1.categories.update.success"
          )
        else
          error_response(
            errors: result.error,
            status: :unprocessable_content,
            message_key: "api.v1.categories.update.failure"
          )
        end
      end

      def destroy
        authorize(category)
        result = Categories::Destroy.result(id: category.id)

        if result.success?
          success_response(
            status: :ok,
            message_key: "api.v1.categories.destroy.success"
          )
        else
          error_response(
            errors: result.error,
            status: :unprocessable_content,
            message_key: "api.v1.categories.destroy.failure"
          )
        end
      end

      private

      def category
        @category ||= Categories::Find.result(id: params[:id]).category
      end

      def category_params
        params.require(:category).permit(:title, :color).to_h.merge(user: current_user)
      end
    end
  end
end
