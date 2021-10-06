require 'spotify'

module Webhooks
  class SpotifyController < ApplicationController
    def create
      Spotify.request_tokens(code: params[:code])

      redirect_to root_path
    end
  end
end
