class MovieComments::Create
  def initialize(user, movie_id, comment)
    @user = user
    @movie_id = movie_id
    @comment = comment
  end

  def execute
    @user.movie_comments.create!(movie_id: @movie_id, comment: @comment)
  end
end
