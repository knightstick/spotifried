# frozen_string_literal: true

require 'action_controller'

module Spotify
  class << self
    def request_tokens(code:)
      # POST https://accounts.spotify.com/api/token
      # REQUEST BODY PARAMETER	VALUE
      # grant_type	Required.
      # As defined in the OAuth 2.0 specification, this field must contain the value "authorization_code".
      # code	Required.
      # The authorization code returned from the initial request to the Account /authorize endpoint.
      # redirect_uri	Required.

      # This parameter is used for validation only (there is no actual redirection). The value of this parameter must exactly match the value of redirect_uri supplied when requesting the authorization code.
      data = {
        grant_type: 'authorization_code',
        redirect_uri: "#{Rails.configuration.host_url}/webhooks/spotify",
        code: code
      }

      token_uri = URI::HTTPS.build(host: 'accounts.spotify.com', path: '/api/token')
      headers = { 'Authorization' => authorization_header }

      puts data.inspect
      puts data.to_query
      response = Net::HTTP.post(token_uri, data.to_query, headers)

      puts "RESPONSE CODE: #{response.code}"
      puts "RESPONSE BODY: #{response.body}"

      JSON.parse(response.body).with_indifferent_access.slice(:access_token, :expires_in, :refresh_token).symbolize_keys
    end

    def create_credential!(access_token:, expires_in:, refresh_token:)
      Spotify::Credential.create!(
        access_token: access_token, expires_in: expires_in, refresh_token: refresh_token
      )
    end

    private

    def authorization_header
      # Basic *<base64 encoded client_id:client_secret>*
      # pair = "#{client_id}:#{client_secret}"
      # "Basic #{Base64.urlsafe_encode64(pair)}".tap { |x| puts "header: #{x}" }
      # OR
      ActionController::HttpAuthentication::Basic.encode_credentials(client_id, client_secret)
    end

    def client_id
      ENV.fetch('SPOTIFY_CLIENT_ID')
    end

    def client_secret
      ENV.fetch('SPOTIFY_CLIENT_SECRET')
    end
  end
end

# require 'net/http'
# require 'uri'
# require 'json'

# uri = URI.parse("http://localhost:3000/users")

# header = {'Content-Type': 'text/json'}
# user = {user: {
#                    name: 'Bob',
#                    email: 'bob@example.com'
#                       }
#             }

# # Create the HTTP objects
# http = Net::HTTP.new(uri.host, uri.port)
# request = Net::HTTP::Post.new(uri.request_uri, header)
# request.body = user.to_json

# # Send the request
# response = http.request(request)
