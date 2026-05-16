require 'rails_helper'

RSpec.describe User, type: :model do
  it "невалиден без имени" do
    user = User.new(name: nil, email: "test@example.com")
    expect(user).not_to be_valid
  end

  it "невалиден без корректного email" do
    user = User.new(name: "Expert", email: "invalid_email")
    expect(user).not_to be_valid
  end
end