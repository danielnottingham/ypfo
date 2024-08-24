# frozen_string_literal: true

class AccountPolicy < ApplicationPolicy
  class Scope < CurrentUserScope
  end

  def index?
    user.present?
  end
end
