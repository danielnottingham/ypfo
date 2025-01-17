# frozen_string_literal: true

class CategoryPolicy < ApplicationPolicy
  class Scope < ApplicationScope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.present?
        scope.where(user:)
      else
        scope.none
      end
    end
  end

  def index?
    user.present?
  end

  def create?
    user.present?
  end

  def update?
    user.present? && owner?
  end
end
