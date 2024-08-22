# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts, id: :uuid do |t|
      t.string :title, null: false, limit: 50
      t.integer :balance_cents, null: false, default: 0
      t.string :balance_currency, null: false, default: "BRL"
      t.string :color, null: false
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :accounts, :title, unique: true
    add_index :accounts, %i[user_id title], unique: true
  end
end
