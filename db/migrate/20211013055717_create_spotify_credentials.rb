class CreateSpotifyCredentials < ActiveRecord::Migration[6.1]
  def change
    create_table :spotify_credentials do |t|
      t.string :access_token, null: false, index: true
      t.string :refresh_token, null: false, index: true
      t.integer :expires_in, null: false

      t.timestamps
    end
  end
end
