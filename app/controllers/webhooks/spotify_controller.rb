require 'spotify'

module Webhooks
  class SpotifyController < ApplicationController
    def create
      tokens = Spotify.request_tokens(code: params[:code])

      access_code = tokens.fetch(:access_token)
      uri = URI('https://api.spotify.com/v1/me')
      req = Net::HTTP::Get.new(uri)
      req['Authorization'] = "Bearer #{access_code}"

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end

      puts res.body

      redirect_to root_path
    end
  end
end
