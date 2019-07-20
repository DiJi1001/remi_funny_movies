class MoviesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]

  def index
    @prev_email = params[:prev_email]
  end

  def new
  end

  def create
    render 'new'
  end
end
