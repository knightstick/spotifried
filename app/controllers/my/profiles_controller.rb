class My::ProfilesController < ApplicationController
  GENRES = [
    'acoustic',
    'chill',
    'classical',
    'dance',
    'funk',
    'heavy-metal',
    'hip-hop',
    'jazz',
    'k-pop',
    'pop',
    'rock',
    'rock-n-roll'
  ]

  def show
    @profile_pic_url = get_profile_picture
    @recommendations = get_recommendations
    @genres = GENRES.map do |genre|
      Genre.new(genre, checked_genre?(genre))
    end
    render 'static/profile'
  end

  private

  Genre = Struct.new(:name, :checked) do
    def checked?
      checked
    end
  end

  def spotify
    @spotify ||= Spotify::Client.new(current_user.spotify_credentials.last)
  end

  def get_profile_picture
    spotify_profile = spotify.get_my_profile
    spotify_profile.picture_url
  end

  def get_recommendations
    if seed_genres.present?
      spotify.get_recommendations(seed_genres)
    else
      spotify.get_recommendations(default_genres)
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  def seed_genres
    params[:genre].join(',')
  end

  def checked_genre?(name)
    params[:genre].include?(name)
  end

  def default_genres
    'rock'
  end
end
