# frozen_string_literal: true

require "rails_helper"

RSpec.describe Category, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:records).dependent(:nullify) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:color) }

    it do
      category = create(:category)
      expect(category).to validate_uniqueness_of(:title).scoped_to(:user_id)
    end

    it { is_expected.to validate_length_of(:title).is_at_most(40) }

    it { is_expected.to allow_value("#FF00aa").for(:color) }
    it { is_expected.not_to allow_value("FF00aa").for(:color) }
    it { is_expected.not_to allow_value("#fff").for(:color) }
    it { is_expected.not_to allow_value("#ff00aaff").for(:color) }
    it { is_expected.not_to allow_value("#ff00zz").for(:color) }
    it { is_expected.not_to allow_value("random value").for(:color) }
  end
end
