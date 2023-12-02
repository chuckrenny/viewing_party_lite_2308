require "rails_helper"

RSpec.describe User, type: :feature do
  before :each do
    @user_1 = create(:user, name: 'John David', email: 'jdavid@aol.com')
    @user_2 = create(:user, name: 'Jane Doe', email: 'jdoe@aol.com')

    @movie_1 = create(:movie, title: 'Jaws')
    @movie_2 = create(:movie, title: 'The Shining')

    @viewing_party1 = create(:viewing_party, duration: 120, day: '2023-12-10', time: '12:30:00', host_id: @user_1.id, movie_id: @movie_1.id)
    @viewing_party2 = create(:viewing_party, duration: 90, day: '2023-10-13', time: '17:15:00', host_id: @user_2.id, movie_id: @movie_2.id)

    PartyUser.create!(user: @user_1, viewing_party: @viewing_party1)
    PartyUser.create!(user: @user_1, viewing_party: @viewing_party2)
    PartyUser.create!(user: @user_2, viewing_party: @viewing_party1)
    PartyUser.create!(user: @user_2, viewing_party: @viewing_party2)
  end

  describe "User Dashboard Page" do
    # US 3
    it "displays a specific user dashboard attributes" do
      visit user_path(@user_1)

      expect(page).to have_content("#{@user_1.name}'s Dashboard")
      expect(page).to have_button("Discover Movies")
    end

    # As a user,
    # When I visit a user dashboard,
    # I should see the viewing parties that the user has been invited to with the following details:

    # Movie Image
    # Movie Title, which links to the movie show page
    # Date and Time of Event
    # who is hosting the event
    # list of users invited, with my name in bold
    # I should also see the viewing parties that the user has created with the following details:

    # Movie Image
    # Movie Title, which links to the movie show page
    # Date and Time of Event
    # That I am the host of the party
    # List of friends invited to the viewing party
    describe "displays the viewing parties the user has been invited to" do
      it "should display the movie image, title as a redirect link," do
        visit user_path(@user_1)

        expect(page).to have_content("John David's Dashboard")
        expect(page).to have_button("Discover Movies")

        within('#viewing_parties') do
          expect(page).to have_content(viewing_party1.movie_title)
          expect(page).to have_content(viewing_party2.movie_title)
        end
      end
    end
  end
end
