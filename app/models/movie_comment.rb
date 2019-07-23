class MovieComment < ApplicationRecord
  validates_presence_of :comment, :user_id, :movie_id
  belongs_to  :movie
  belongs_to  :user
end
