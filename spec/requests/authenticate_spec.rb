require "rails_helper"

RSpec.describe "Authentication" do
  before do
    @foo = User.create!(
      full_name: "Foo",
      email: "foo@mail.com",
      password: "foo@password",
    )
  end

  it "successfully user sign in" do
    post_json "/login", { email: "foo@mail.com", password: "foo@password" }
    expect_response(
      :ok,
      data: {
        id: @foo.id,
        email: @foo.email,
        full_name: @foo.full_name,
        token: String,
      },
    )
  end

  it "invalid user's email or password" do
    post_json "/login", { email: "foo@mail.com", password: "foo@pass" }
    expect_error_response(:unprocessable_entity, "Invalid email or password")
  end

  it "invalid unregistered user" do
    post_json "/login", { email: "own@mail.com", password: "own@pass" }
    expect_error_response(:unprocessable_entity, "Invalid email or password")
  end
end
