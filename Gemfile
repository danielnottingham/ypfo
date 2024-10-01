# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.3.5"

gem "active_model_serializers", "0.10.14"
gem "bootsnap", "1.18.4", require: false
gem "devise", "4.9.4"
gem "devise-api", "0.2.0"
gem "dotenv-rails", "3.1.4"
gem "enumerate_it", "4.0.0"
gem "money", "6.19.0"
gem "pagy", "9.0.9"
gem "pg", "1.5.8"
gem "puma", "6.4.2"
gem "pundit", "2.3.2"
gem "rack-cors", "2.0.2"
gem "rails", "7.1.4"
gem "redis", "5.2.0"
gem "rswag", "2.13.0"
gem "service_actor", "3.9.2"
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "factory_bot_rails", "6.2.0"
  gem "rubocop-performance", "1.21.0"
  gem "rubocop-rails", "2.25.1", require: false
end

group :development do
  gem "brakeman", "6.2.1"
  gem "reek", "6.3.0"
end

group :test do
  gem "rspec-rails", "6.1.0"
  gem "shoulda-matchers", "5.3.0"
  gem "simplecov", "0.22.0", require: false
end
