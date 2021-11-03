class CreateUsersSpotifyCredentials < ActiveRecord::Migration[6.1]
  def change
    create_table :users_spotify_credentials do |t|
      t.references :user, null: false, foreign_key: true
      t.references :spotify_credential, null: false, foreign_key: true

      t.timestamps
    end
  end
end
