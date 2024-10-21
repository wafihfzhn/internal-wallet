require "rails_helper"

RSpec.describe User do
  before do
    @zoo = create_user(email: "zoo@mail.com")
    @foo =  described_class.new(
      full_name: "Foo",
      email: "foo@mail.com",
      password: "foo@password",
    )
  end

  it "valid user attributes" do
    expect(@foo).to be_valid
  end

  it "validate of nil email" do
    @foo.email = nil
    expect(@foo).not_to be_valid
  end

  it "validate of nil full name" do
    @foo.full_name = nil
    expect(@foo).not_to be_valid
  end

  it "validate of nil password" do
    @foo.password = nil
    expect(@foo).not_to be_valid
  end

  it "validate of email already exists" do
    @foo.email = "zoo@mail.com"
    expect(@foo).not_to be_valid
  end
end
