class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  private

  def authenticate_user!
    unless logged_in?
      flash[:danger] = I18n.t('users.login.required_login')
      redirect_to root_url
    end
  end
end
