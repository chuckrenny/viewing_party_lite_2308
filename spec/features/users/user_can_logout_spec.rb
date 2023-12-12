require "rails_helper"

RSpec.describe "Logging out" do
  # As a logged in user
  # When I visit the landing page
  # I no longer see a link to Log In or Create an Account
  # But I see a link to Log Out.
  # When I click the link to Log Out
  # I'm taken to the landing page
  # And I can see that the Log Out link has changed back to a Log In link
  it "can logout and remove session keys" do
    user = create :user

    visit login_path

    fill_in :username, with: user.email
    fill_in :password, with: user.password
    click_on "Log In"

    expect(current_path).to eq(root_path)
    expect(page).to_not have_content "Log In"
    expect(page).to_not have_content "Create User"
    click_button "Log Out"

    expect(current_path).to eq root_path

    expect(page).to have_content "Log In"
    expect(page).to have_content "Create User"
  end
end
