# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.2.2"

gem "bootsnap", require: false
gem "dotenv-rails", "2.8.1"
gem "pg", "1.5.6"
gem "puma", "6.4.2"
gem "rack-cors", "2.0.2"
gem "rails", "7.1.3.4"
gem "redis", "5.2.0"
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "rubocop-performance", "1.21.0"
  gem "rubocop-rails", "2.25.1", require: false
end

group :development do
  gem "brakeman", "6.1.2"
  gem "reek", "6.3.0"
end
