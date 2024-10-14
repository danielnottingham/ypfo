# frozen_string_literal: true

module Categories
  class List < Actor
    input :scope, type: ActiveRecord::Relation, default: -> { Category.all }

    output :categories, type: Enumerable

    def call
      self.categories = scope.order(created_at: :desc)
    end
  end
end
