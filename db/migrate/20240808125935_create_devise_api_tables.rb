# frozen_string_literal: true

class CreateDeviseApiTables < ActiveRecord::Migration[7.1]
  def change
    create_table :devise_api_tokens, id: :uuid do |t|
      t.belongs_to :resource_owner, null: false, polymorphic: true, index: true, type: :uuid
      t.string :access_token, null: false, index: true
      t.string :refresh_token, null: true, index: true
      t.integer :expires_in, null: false
      t.datetime :revoked_at, null: true
      t.string :previous_refresh_token, null: true, index: true

      t.timestamps
    end
  end
end
