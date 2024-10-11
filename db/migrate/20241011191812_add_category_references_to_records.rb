# frozen_string_literal: true

class AddCategoryReferencesToRecords < ActiveRecord::Migration[7.2]
  def change
    add_reference :records, :category, foreign_key: true, type: :uuid, index: true
  end
end
