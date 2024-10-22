source "https://rubygems.org"

gem "rails", "~> 7.2"
gem "pg", "~> 1.5"
gem "puma", "~> 6.4"
gem "bcrypt", "~> 3.1"
gem "jwt", "~> 2.9"
gem "faraday", "~> 2.12"
gem "pagy", "~> 9.1"

gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "rubocop-rails-omakase", require: false
  gem "brakeman", require: false
  gem "rspec-rails", "~> 7.0"
  gem "dotenv", "~> 3.1"
end
