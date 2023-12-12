require "rails_helper"

RSpec.describe "New Viewing Party Page" do
  before do
    @user1 = User.create!(name: "TP", email: "tp@gmail.com", password: "test", password_confirmation: "test")
    @user2 = User.create!(name: "Charles", email: "charles@gmail.com", password: "test", password_confirmation: "test")
    @user3 = User.create!(name: "Chris", email: "chris@gmail.com", password: "test", password_confirmation: "test")

    VCR.use_cassette("godfather-movie-details") do
      @movie = MovieFacade.movie(238)
      visit new_user_movie_viewing_party_path(user_id: @user1.id, movie_id: @movie.id)
    end
  end

  # When I visit the new viewing party page (/users/:user_id/movies/:movie_id/viewing-party/new, where :user_id is a valid user's id),
  # I should see the name of the movie title rendered above a form with the following fields:
  # Duration of Party with a default value of movie runtime in minutes; a viewing party should NOT be created if set to a value less than the duration of the movie
  # When: field to select date
  # Start Time: field to select time
  # Checkboxes next to each existing user in the system
  # Button to create a party
  # Details When the party is created,
  # the user should be redirected back to the dashboard where the new event is shown.
  # The event should also be listed on any other user's dashboards that were also invited to the party.

  describe "new viewing party form" do
    it "displays the movie title above a form" do
      within "#form-group" do
        expect(page).to have_content(@movie.title)
      end
    end

    it "has a 'Duration of Party' field prefilled with the movie's runtime in minutes" do
      expect(page).to have_field(:duration_of_party, with: @movie.runtime)
    end

    it "has date and time selection fields" do
      expect(page).to have_field("Day")
    end

    it "has individual checkboxes to invite every other existing user" do
      expect(page).to have_unchecked_field(@user2.formatted)
      expect(page).to have_unchecked_field(@user3.formatted)

      expect(page).to_not have_checked_field(@user1.formatted)
    end

    it "has a button to create a party" do
      expect(page).to have_button("Create Party").once
    end
  end

  describe "happy path" do
    it "redirects to the user's dashboard where the new event is shown", :vcr do
      check(@user2.formatted)
      fill_in :day, with: "12/01/2023"
      fill_in :start_time, with: "03:00 PM"

      click_button("Create Party")

      expect(current_path).to eq(user_path(@user1))
      within ".parties" do
        expect(page).to have_content(@movie.title)
      end

      visit user_path(@user2.id)
      expect(page).to have_content(@movie.title)
    end
  end
end
