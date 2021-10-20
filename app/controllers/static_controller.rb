class StaticController < ApplicationController
  def index
    @authorize_url = authorize_uri.to_s
  end

  private

  def authorize_uri
    params = {
      client_id: client_id,
      redirect_uri: "#{Rails.configuration.host_url}/webhooks/spotify",
      response_type: 'code'
    }

    URI::HTTPS.build(host: 'accounts.spotify.com', path: '/authorize', query: params.to_query)
  end

  def client_id
    ENV.fetch('SPOTIFY_CLIENT_ID')
  end
end
