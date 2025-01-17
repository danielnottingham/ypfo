# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.3.6"

gem "active_model_serializers", "0.10.14"
gem "bootsnap", "1.18.4", require: false
gem "devise", "4.9.4"
gem "devise-api", "0.2.0"
gem "dotenv-rails", "3.1.4"
gem "enumerate_it", "4.0.0"
gem "money", "6.19.0"
gem "ostruct", "0.6.0"
gem "pagy", "9.0.9"
gem "pg", "1.5.8"
gem "puma", "6.4.3"
gem "pundit", "2.4.0"
gem "rack-cors", "2.0.2"
gem "rails", "7.2.1"
gem "redis", "5.3.0"
gem "rswag", "2.14.0"
gem "service_actor", "3.9.4"
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  gem "bullet", "7.2.0"
  gem "debug", platforms: %i[mri windows]
  gem "factory_bot_rails", "6.4.3"
  gem "pry", "0.14.2"
  gem "pry-rails", "0.3.11"
  gem "rubocop-performance", "1.22.1"
  gem "rubocop-rails", "2.26.2", require: false
end

group :development do
  gem "brakeman", "7.0.0"
  gem "reek", "6.4.0"
end

group :test do
  gem "rspec-rails", "7.0.1"
  gem "shoulda-matchers", "6.4.0"
  gem "simplecov", "0.22.0", require: false
end
