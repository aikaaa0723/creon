class CreateTweets < ActiveRecord::Migration[7.2]
  def change
    create_table :tweets do |t|
      t.string :caption
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
