# frozen_string_literal: true

module Api
  module V1
    class CategorySerializer < ActiveModel::Serializer
      attributes :id, :title, :color, :user_id
    end
  end
end
