class CreateIdeals < ActiveRecord::Migration[5.0]
  def change
    create_table :ideals do |t|
      t.references :user, null: false
      t.string :user_image
      t.boolean :twitter_post, null: false, default: false
      t.string :twitter_username

      t.timestamps
    end

    add_foreign_key :ideals, :users
  end
end
