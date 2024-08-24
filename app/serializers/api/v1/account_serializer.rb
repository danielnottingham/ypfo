# frozen_string_literal: true

module Api
  module V1
    class AccountSerializer < ActiveModel::Serializer
      attributes :id, :title, :balance_cents, :balance_currency, :color, :user_id
    end
  end
end
