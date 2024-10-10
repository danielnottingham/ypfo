# frozen_string_literal: true

class RecordPolicy < ApplicationPolicy
  class Scope < ApplicationScope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.present?
        scope.joins(:account).where(accounts: { user: })
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

  private

  def owner?
    user == record.account.user
  end
end
