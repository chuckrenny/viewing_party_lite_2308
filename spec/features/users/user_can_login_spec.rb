require "rails_helper"

RSpec.describe "Logging In" do
  it "can log in with valid credentials" do
    user = create :user

    visit root_path

    click_on "Log In"

    expect(current_path).to eq(login_path)

    fill_in :username, with: user.email
    fill_in :password, with: user.password

    click_on "Log In"

    expect(current_path).to eq(root_path)

    expect(page).to have_content("Welcome, #{user.name}")
  end

  it "cannot log in with bad credentials" do
    user = create :user

    # we don't have to go through root_path and click the "I have an account" link any more
    visit login_path

    fill_in :username, with: user.email
    fill_in :password, with: "incorrect password"

    click_on "Log In"

    expect(current_path).to eq(login_path)

    expect(page).to have_content("Sorry, your credentials are bad.")
  end
end
