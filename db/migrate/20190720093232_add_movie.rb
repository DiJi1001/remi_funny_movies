class AddMovie < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.references :user, foreign_key: true, null: false
      t.string :video_id, null: false
      t.string :shared_url
      t.string :title, null: false
      t.string :description
      t.timestamps
    end
  end
end
