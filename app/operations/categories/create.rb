# frozen_string_literal: true

module Categories
  class Create < Actor
    input :params, type: Hash

    output :category, type: Category

    def call
      self.category = Category.new(params)

      fail!(error: category.errors.full_messages) unless category.save
    end
  end
end
