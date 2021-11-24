class My::ProfilesController < ApplicationController
  def show
    @profile_pic_url = get_profile_picture
    @recommendations = get_recommendations
    render 'static/profile'
  end

  private

  def spotify
    @spotify ||= Spotify::Client.new(current_user.spotify_credentials.last)
  end

  def get_profile_picture
    spotify_profile = spotify.get_my_profile
    spotify_profile.picture_url
  end

  def get_recommendations
    spotify.get_recommendations(seed_genres)
  end

  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  # {"genres"=>["acoustic", "afrobeat", "alt-rock", "alternative", "ambient", "anime", "black-metal", "bluegrass", "blues", "bossanova", "brazil", "breakbeat", "british", "cantopop", "chicago-house", "children", "chill", "classical", "club", "comedy", "country", "dance", "dancehall", "death-metal", "deep-house", "detroit-techno", "disco", "disney", "drum-and-bass", "dub", "dubstep", "edm", "electro", "electronic", "emo", "folk", "forro", "french", "funk", "garage", "german", "gospel", "goth", "grindcore", "groove", "grunge", "guitar", "happy", "hard-rock", "hardcore", "hardstyle", "heavy-metal", "hip-hop", "holidays", "honky-tonk", "house", "idm", "indian", "indie", "indie-pop", "industrial", "iranian", "j-dance", "j-idol", "j-pop", "j-rock", "jazz", "k-pop", "kids", "latin", "latino", "malay", "mandopop", "metal", "metal-misc", "metalcore", "minimal-techno", "movies", "mpb", "new-age", "new-release", "opera", "pagode", "party", "philippines-opm", "piano", "pop", "pop-film", "post-dubstep", "power-pop", "progressive-house", "psych-rock", "punk", "punk-rock", "r-n-b", "rainy-day", "reggae", "reggaeton", "road-trip", "rock", "rock-n-roll", "rockabilly", "romance", "sad", "salsa", "samba", "sertanejo", "show-tunes", "singer-songwriter", "ska", "sleep", "songwriter", "soul", "soundtracks", "spanish", "study", "summer", "swedis", "synth-pop", "tango", "techno", "trance", "trip-hop", "turkish", "work-out", "world-music"]}
  def seed_genres
    params[:genres] || 'classical,country'
  end
end
