require "rails_helper"

RSpec.describe User do
  let(:user) do
    described_class.new(
      full_name: "Foo",
      email: "foo@mail.com",
      password: "foo@password",
    )
  end

  it "successfully create the user" do
    expect(user).to be_valid
  end

  it "validate of nil full name" do
    user.full_name = nil
    expect(user).not_to be_valid
  end

  it "validate of nil email" do
    user.email = nil
    expect(user).not_to be_valid
  end

  it "validate of nil password" do
    user.password = nil
    expect(user).not_to be_valid
  end
end
