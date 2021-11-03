class My::ProfilesController < ApplicationController
  def show
    @profile_pic_url = use_token_for_profile_picture(current_user.spotify_credentials.last)
    use_token_for_genres(current_user.spotify_credentials.last)
    @song_titles = use_token_for_recommendations(current_user.spotify_credentials.last)
    render 'static/profile'
  end

  private

  def use_token_for_profile_picture(credential)
    response = fetch_user_data_from_spotify(credential)
    response[:images][0][:url]
  end

  def use_token_for_recommendations(credential)
    response = fetch_recommendation_from_spotify(credential)
    puts response
    response[:tracks].map { |track| track[:name] }
  end

  def fetch_user_data_from_spotify(credential)
    access_token = credential.access_token
    uri = URI('https://api.spotify.com/v1/me')
    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = "Bearer #{access_token}"

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end

    JSON.parse(res.body).with_indifferent_access
  end

  def use_token_for_genres(credential)
    access_token = credential.access_token
    uri = URI('https://api.spotify.com/v1/recommendations/available-genre-seeds')
    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = "Bearer #{access_token}"

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end

    puts JSON.parse(res.body).with_indifferent_access
  end

  def fetch_recommendation_from_spotify(credential)
    access_token = credential.access_token
    uri = URI('https://api.spotify.com/v1/recommendations')
    params = { seed_genres: seed_genres }
    uri.query = URI.encode_www_form(params)

    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = "Bearer #{access_token}"

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end

    JSON.parse(res.body).with_indifferent_access
  end

  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  # {"genres"=>["acoustic", "afrobeat", "alt-rock", "alternative", "ambient", "anime", "black-metal", "bluegrass", "blues", "bossanova", "brazil", "breakbeat", "british", "cantopop", "chicago-house", "children", "chill", "classical", "club", "comedy", "country", "dance", "dancehall", "death-metal", "deep-house", "detroit-techno", "disco", "disney", "drum-and-bass", "dub", "dubstep", "edm", "electro", "electronic", "emo", "folk", "forro", "french", "funk", "garage", "german", "gospel", "goth", "grindcore", "groove", "grunge", "guitar", "happy", "hard-rock", "hardcore", "hardstyle", "heavy-metal", "hip-hop", "holidays", "honky-tonk", "house", "idm", "indian", "indie", "indie-pop", "industrial", "iranian", "j-dance", "j-idol", "j-pop", "j-rock", "jazz", "k-pop", "kids", "latin", "latino", "malay", "mandopop", "metal", "metal-misc", "metalcore", "minimal-techno", "movies", "mpb", "new-age", "new-release", "opera", "pagode", "party", "philippines-opm", "piano", "pop", "pop-film", "post-dubstep", "power-pop", "progressive-house", "psych-rock", "punk", "punk-rock", "r-n-b", "rainy-day", "reggae", "reggaeton", "road-trip", "rock", "rock-n-roll", "rockabilly", "romance", "sad", "salsa", "samba", "sertanejo", "show-tunes", "singer-songwriter", "ska", "sleep", "songwriter", "soul", "soundtracks", "spanish", "study", "summer", "swedis", "synth-pop", "tango", "techno", "trance", "trip-hop", "turkish", "work-out", "world-music"]}
  def seed_genres
    params[:genres] || 'classical,country'
  end
end
