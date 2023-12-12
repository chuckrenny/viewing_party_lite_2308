# frozen_string_literal: true

class ViewingParty < ApplicationRecord
  validates :host_id, :duration, :day, :time, :movie_id, presence: true

  belongs_to :movie
  has_many :party_users

  after_create :attach_movie_poster

  def user_status(id)
    if id == host_id
      "Hosting"
    else
      "Invited"
    end
  end

  def time_formatted
    time.strftime("%H:%M")
  end

  private

  def attach_movie_poster
    # Call your API service to retrieve the poster
    TMDBService.get_poster(movie.poster_path)

    movie.poster.attach(
      io: File.open("app/assets/images" + movie.poster_path),
      filename: movie.poster_path.delete("/"),
      content_type: "image/jpeg"
    )
  end
end
