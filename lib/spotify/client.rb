module Spotify
  class Client
    def initialize(credential)
      @credential = credential
    end

    Profile = Struct.new(:profile_hash) do
      def picture_url
        profile_hash.dig(:images, 0, :url)
      end
    end

    Recommendations = Struct.new(:recommendations_hash) do
      include Enumerable

      def each(&block)
        tracks.each(&block)
      end

      def tracks
        recommendations_hash[:tracks].map { |t| Track.new(t) }
      end
    end

    Track = Struct.new(:track_hash) do
      def name
        track_hash[:name]
      end

      def artists
        track_hash[:artists].map { |a| Artist.new(a) }
      end

      def spotify_url
        "https://open.spotify.com/track/#{track_hash[:id]}"
      end
    end

    Artist = Struct.new(:artist_hash) do
      def name
        artist_hash[:name]
      end
    end

    def get_my_profile
      response = send_request('https://api.spotify.com/v1/me')
      Profile.new(parse_response(response))
    end

    def get_recommendations(seed_genres)
      response = send_request('https://api.spotify.com/v1/recommendations', { seed_genres: seed_genres })
      Recommendations.new(parse_response(response))
    end

    private

    attr_reader :credential

    def access_token
      credential.access_token
    end

    def authorization_header
      "Bearer #{access_token}"
    end

    def send_request(uri, params = {})
      uri = URI(uri)
      uri.query = URI.encode_www_form(params)
      req = Net::HTTP::Get.new(uri)
      req['Authorization'] = authorization_header
      Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end
    end

    def parse_response(response)
      JSON.parse(response.body).with_indifferent_access
    end
  end
end
