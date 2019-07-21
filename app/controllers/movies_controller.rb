class MoviesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]

  def index
    @prev_email = params[:prev_email]
    @movies = Movies::Fetch.new(params[:page]).execute
  end

  def new; end

  def create
    service = Movies::Share.new(current_user, params[:youtube_url])
    if service.execute
      flash[:success] = I18n.t('movies.sharing.share_successfully')
      redirect_to root_url
    else
      flash.now[:danger] = service.error_message
      render 'new'
    end
  end
end
