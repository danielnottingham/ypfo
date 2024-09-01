# frozen_string_literal: true

module Respondable
  extend ActiveSupport::Concern

  def success_response(data:, status: :ok, message: nil, serializer: nil, pagination: nil)
    response = { status: "success", message: message, data: formated_response(data, serializer) }
    response[:pagination] = pagination if pagination.present?

    render json: response, status: status
  end

  def error_response(errors:, status: :unprocessable_content, message: nil)
    response = { status: "error", message: message, errors: errors }

    render json: response, status: status
  end

  private

  def formated_response(data, serializer)
    if data.is_a?(Array) || data.is_a?(ActiveRecord::Relation)
      return { resource_plural_name(data.first) => [] } if data.empty?

      { resource_plural_name(data.first) => serialized_data(data, serializer) }
    else
      { resource_singular_name(data) => serialized_resource(data, serializer) }
    end
  end

  def serialized_data(resource, serializer)
    ActiveModelSerializers::SerializableResource.new(resource, each_serializer: serializer)
  end

  def serialized_resource(resource, serializer)
    ActiveModelSerializers::SerializableResource.new(resource, serializer: serializer)
  end

  def resource_singular_name(resource)
    return resource.adapter.class.model_name.singular if resource.is_a?(ActiveModelSerializers::SerializableResource)

    resource.class.model_name.singular
  end

  def resource_plural_name(resource)
    return controller_name unless resource
    return resource.adapter.class.model_name.plural if resource.is_a?(ActiveModelSerializers::SerializableResource)

    resource.class.model_name.plural
  end
end
