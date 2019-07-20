class Movie < ApplicationRecord
  validates_presence_of :user_id, :video_id, :title
  belongs_to  :user
end
