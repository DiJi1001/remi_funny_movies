describe UsersController do
  describe 'POST: /login' do
    let(:email) { 'eddie.redmayne@gmail.com' }
    let(:password) { Faker::Internet.password(6, 20) }

    context 'when email is existing and password is correct' do
      let!(:user) { create :user, email: email, password: password }

      before { post :login, params: { email: email, password: password } }

      it 'user is logged in and redirect to home page with successful message' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_url)
        expect(session[:user_id]).to eq user.id
        expect(flash[:success]).to eq I18n.t('users.login.login_successfully')
      end
    end

    context 'when email is existing and password is incorrect' do
      let!(:user) { create :user, email: email, password: password }

      before { post :login, params: { email: email, password: "wrong_#{password}" } }

      it 'user is not logged in and redirect to home page with error message' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_url(prev_email: email))
        expect(session[:user_id]).to be_nil
        expect(flash[:danger]).to eq I18n.t('users.login.incorrect_password')
      end
    end

    context 'when email is not existing, email and password are valid' do
      let(:user) { User.find_by(email: email) }

      before { post :login, params: { email: email, password: password } }

      it 'user is registered and logged in and redirect to home page with successful message' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_url)
        expect(session[:user_id]).to eq user.id
        expect(flash[:success]).to eq I18n.t('users.login.register_login_successfully')
      end
    end

    context 'when email is not existing and invalid' do
      let(:invalid_email) { 'invalid_email' }
      before { post :login, params: { email: invalid_email, password: password } }

      it 'user is not registered and redirect to home page with error message' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_url(prev_email: invalid_email))
        expect(session[:user_id]).to be_nil
        expect(flash[:danger]).to eq [I18n.t('activerecord.errors.models.user.attributes.email.invalid')]
      end
    end

    context 'when email is not existing and valid but password is too short' do
      before { post :login, params: { email: email, password: 'short' } }

      it 'user is not registered and redirect to home page with error message' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_url(prev_email: email))
        expect(session[:user_id]).to be_nil
        expect(flash[:danger]).to eq [I18n.t('activerecord.errors.models.user.attributes.password.too_short', count: User::PASSWORD_MIN_LENGTH)]
      end
    end

    context 'when there is not either email or password' do
      before { post :login }

      it 'user is not registered and redirect to home page with error messages' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_url)
        expect(session[:user_id]).to be_nil
        expect(flash[:danger]).to match_array [
          I18n.t('activerecord.errors.models.user.attributes.email.blank'),
          I18n.t('activerecord.errors.models.user.attributes.email.invalid'),
          I18n.t('activerecord.errors.models.user.attributes.password.blank'),
          I18n.t('activerecord.errors.models.user.attributes.password.too_short', count: User::PASSWORD_MIN_LENGTH)
        ]
      end
    end
  end

  describe 'POST: /logout' do
    before { delete :logout }

    it 'log user out and redirect to home page', :aggregate_failures do
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_url)
      expect(response.cookies).to be_blank
      expect(session[:user_id]).to be_nil
    end
  end
end
