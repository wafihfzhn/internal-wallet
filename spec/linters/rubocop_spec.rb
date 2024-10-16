require "rails_helper"

RSpec.describe "Rubocop" do
  it "rubocop test all" do
    result = `rubocop`
    expect(/no\ offenses\ detected/).to match(result)
  end
end
