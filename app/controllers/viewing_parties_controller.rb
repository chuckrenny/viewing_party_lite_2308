class ViewingPartiesController < ApplicationController
  def new
    @user = User.find(params[:user_id])
    @movie = MovieFacade.movie(params[:movie_id])
    @invitees = @user.friends
  end

  def create
    # find the movie in AR or create and add it
    mov = Movie.find_or_create_by(id: params[:movie_id]) do |model|
      # convert poro::movie to ar::movie
      m = MovieFacade.movie(params[:movie_id])
      model.title = m.title
      model.poster_path = m.poster_path
      model.runtime = m.runtime
    end

    vp = ViewingParty.create!(
      duration: params[:duration_of_party],
      day: params[:day],
      time: params[:start_time],
      host_id: params[:user_id],
      movie_id: mov.id
    )

    # create party user for the host
    PartyUser.create!(viewing_party_id: vp.id, user_id: params[:user_id])

    # create party user for each friend
    params[:user_ids].reject! { |element| element == "" }.each do |user_id|
      PartyUser.create!(viewing_party_id: vp.id, user_id: user_id)
    end

    redirect_to user_path(params[:user_id])
  end
end
