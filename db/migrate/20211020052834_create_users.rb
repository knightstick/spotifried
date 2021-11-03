class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :spotify_id, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
