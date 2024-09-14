# frozen_string_literal: true

require "rails_helper"

RSpec.describe Records::Types, type: :enumeration do
  describe ".list" do
    it "returns record_types" do
      expect(described_class.list).to eq([-1, 1])
    end
  end
end
