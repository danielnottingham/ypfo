# frozen_string_literal: true

class CreateRecords < ActiveRecord::Migration[7.1]
  def change # rubocop:disable Metrics/MethodLength
    create_table :records, id: :uuid do |t|
      t.string :title, null: false, limit: 70
      t.integer :amount_cents, null: false, default: 0
      t.string :amount_currency, null: false, default: "BRL"
      t.integer :record_type, null: false
      t.date :occurred_in, null: false
      t.string :payee
      t.text :description
      t.references :account, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
