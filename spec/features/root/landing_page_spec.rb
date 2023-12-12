require "rails_helper"

RSpec.describe "Landing Page", type: :feature do
  # When a user visits the root path they should be on the landing page ('/') which includes:
  # Title of Application
  # Button to Create a New User
  # List of Existing Users which links to the users dashboard
  # Link to go back to the landing page (this link will be present at the top of all pages)
  describe "welcome#root" do
    it "has the app's title" do
      visit root_path

      expect(page).to have_content "Viewing Party Lite"
    end

    it "shows home button on persistent nav bar" do
      user = create :user

      visit user_path(user)

      expect(page).to have_link "Home"
    end

    context "visitor arrives" do
      # As a visitor
      # When I visit the landing page
      # I do not see the section of the page that lists existing users
      it "has a button to create a new user" do
        user = create :user

        visit root_path

        expect(page).to have_button "Create User"

        expect(page).to_not have_content user.email
      end
    end

    context "registered user arrives" do
      # As a registered user
      # When I visit the landing page
      # The list of existing users is no longer a link to their show pages
      # But just a list of email addresses
      it "shows existing users with no links to their dashboards" do
        user = create :user
        user2 = create :user

        visit login_path
        fill_in :username, with: user.email
        fill_in :password, with: user.password
        click_button "Log In"

        expect(page).to_not have_link user2.email
        expect(page).to have_content user2.email
      end
    end
  end
end
