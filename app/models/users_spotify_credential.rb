class UsersSpotifyCredential < ApplicationRecord
  belongs_to :user
  belongs_to :spotify_credential, class_name: Spotify::Credential.name
end
