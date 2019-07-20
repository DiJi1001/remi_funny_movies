class UsersController < ApplicationController
  def login
    user = User.find_by(email: params[:email]&.downcase)
    if user
      if user.right_password?(params[:password])
        log_in(user)
        flash[:success] = I18n.t('users.login.login_successfully')
        redirect_to root_url
      else
        flash[:danger] = I18n.t('users.login.incorrect_password')
        redirect_to root_url(prev_email: params[:email])
      end
    else
      user = User.new(email: params[:email], password: params[:password])
      if user.save
        log_in(user)
        flash[:success] = I18n.t('users.login.register_login_successfully')
        redirect_to root_url
      else
        flash[:danger] = []
        user.errors.messages.values.flatten.each do |error_msg|
          flash[:danger] << error_msg
        end
        redirect_to root_url(prev_email: params[:email])
      end
    end
  end

  def logout
    log_out
    redirect_to root_url
  end
end
