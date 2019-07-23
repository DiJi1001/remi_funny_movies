class CreateMovieComment < ActiveRecord::Migration[5.2]
  def change
    create_table :movie_comments do |t|
      t.references :movie, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.string :comment, null: false
      t.timestamps
    end
  end
end
