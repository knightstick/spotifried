class StaticController < ApplicationController
  def index
    @authorize_url = authorize_uri.to_s
  end

  private

  def authorize_uri
    params = {
      client_id: client_id,
      redirect_uri: 'https://3999-13-55-60-236.ngrok.io',
      response_type: 'code'
    }

    URI::HTTPS.build(host: 'accounts.spotify.com', path: '/authorize', query: params.to_query)
  end

  def client_id
    'd8bf254bdfdc4c3d9c211161a57748b1'
  end
end