# frozen_string_literal: true

module Categories
  class Update < Actor
    input :id, type: String
    input :params, type: Hash

    output :category, type: Category

    def call
      self.category = Category.find(id)

      fail!(error: category.errors.full_messages) unless category.update(params)
    end
  end
end
