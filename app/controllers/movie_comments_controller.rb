class MovieCommentsController < ApplicationController
  before_action :authenticate_user!, only: :create

  def create
    MovieComments::Create.new(current_user, params[:movie_id], params[:comment]).execute
    flash[:success] = I18n.t('movie_comments.created_successfully')
    redirect_to root_url
  end
end
