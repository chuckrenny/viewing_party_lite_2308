require "rails_helper"
require_relative "../../app/services/tmdb_service"

RSpec.describe TMDBService do
  describe "class methods" do
    describe "::conn" do
      it "creates a faraday connection" do
        conn = TMDBService.conn

        expect(conn).to be_a Faraday::Connection
        expect(conn.headers.keys).to include "Authorization"
      end
    end

    describe "::poster_conn" do
      it "establishes valid poster connection with auth token" do
        conn = TMDBService.poster_conn

        expect(conn).to be_a Faraday::Connection
        expect(conn.headers.keys).to include "Authorization"
      end
    end

    describe "::json_from_url" do
      it "parses url path to base url and returns the json body", :vcr do
        json = TMDBService.json_from_url("discover/movies")
        expect(json).to be_a Hash
      end
    end

    describe "::top_rated" do
      it "returns top movies", :vcr do
        movies = TMDBService.top_rated
        expect(movies).to be_an Array
        movie_data = movies.first

        expect(movie_data).to have_key :id
        expect(movie_data[:id]).to be_a(Integer)

        expect(movie_data).to have_key :title
        expect(movie_data[:title]).to be_a(String)

        expect(movie_data).to have_key :vote_average
        expect(movie_data[:vote_average]).to be_a(Float)

        expect(movie_data).to have_key :genre_ids
        expect(movie_data[:genre_ids]).to be_a(Array)

        expect(movie_data).to have_key :overview
        expect(movie_data[:overview]).to be_a(String)

        expect(movie_data).to have_key :poster_path
        expect(movie_data[:poster_path]).to be_a(String)
      end
    end

    describe "::search_movies" do
      it "builds a query parameter for a given string and returns index", :vcr do
        search = TMDBService.search_movies("Fastball")
        expect(search).to be_an Array
        expect(search.map { |movie| movie[:title].downcase }).to include "fastball"
      end
    end

    describe "::get_movie" do
      it "gets the movie details api call", :vcr do
        details = TMDBService.get_movie(238)  # The Godfather
        expect(details).to be_a Hash
        expect(details[:title]).to eq "The Godfather"
      end
    end

    describe "::get_cast_and_reviews_for_movie" do
      it "makes end point api calls for the cast and reviews", :vcr do
        cast_reviews = TMDBService.get_cast_and_reviews_for_movie(238)
        expect(cast_reviews[:cast].length).to be <= 10
        expect(cast_reviews[:reviews]).to be_an Array
      end
    end

    describe "::get_poster" do
      it "gets the media at a poster path", :vcr do
        poster_path = "/v0PI2XUPrse8pNhu2MWlul6u1S7.jpg"
        media_status = TMDBService.get_poster(poster_path)

        expect(media_status).to eq 200
        expect(File).to exist "app/assets/images" + poster_path
      end
    end
  end
end
