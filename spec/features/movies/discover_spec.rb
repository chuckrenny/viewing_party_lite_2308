require "rails_helper"

RSpec.describe "Discover Movies", type: :feature do
  before(:each) do
    @user = create :user
  end

  # As a user,
  # When I go to a user dashboard,
  # and click "Discover Movies" button,
  # I am redirected to a discover page /users/:id/discover,
  # where :id is the user id of the user who's dashboard I was just on.
  describe "redirect action from user dashboard" do
    it "routes from user dashboard to the discover movies page" do
      visit user_path(@user)

      click_button "Discover Movies"

      expect(page).to have_current_path discover_user_path(@user)
    end
  end
end
