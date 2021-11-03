class User < ApplicationRecord
  validates :spotify_id,
            uniqueness: true,
            presence: true

  has_many :users_spotify_credentials
  has_many :spotify_credentials, through: :users_spotify_credentials, class_name: Spotify::Credential.name
end
