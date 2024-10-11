# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :categories, id: :uuid do |t|
      t.string :title, limit: 40, null: false
      t.string :color, null: false
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :categories, %i[user_id title], unique: true
  end
end
