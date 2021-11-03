require 'spotify'

module Webhooks
  class SpotifyController < ApplicationController
    def create
      tokens = Spotify.request_tokens(code: params[:code])
      # persist the token
      credential = Spotify.create_credential!(**tokens)

      # lookup spotify user
      data = fetch_user_data_from_spotify(credential)
      spotify_id = data.fetch(:id)
      puts "#### SPOTIFY ID: #{spotify_id}"

      # find or create the spotifried user by spotify_id
      user = User.find_or_create_by!(spotify_id: spotify_id)
      # link the user and the token
      user.spotify_credentials << credential

      # show the spotifried user
      session[:user_id] = user.id

      # but for now just get the profile pic URL

      redirect_to my_profile_path
    end

    private

    def use_token_for_profile_picture(credential)
      response = fetch_user_data_from_spotify(credential)
      response[:images][0][:url]
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
  end
end
