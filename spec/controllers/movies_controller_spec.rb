RSpec.describe MoviesController do
  xdescribe 'GET: /movies' do
  end

  describe 'GET: /movies/share' do
    context 'when user does not login yet' do
      before { get :new }

      it 'redirect to home page with error message' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_url)
        expect(flash[:danger]).to eq I18n.t('users.login.required_login')
      end
    end

    xcontext 'when user has logged in'
  end

  describe 'POST: /movies' do
    context 'when user does not login yet' do
      before { post :create }

      it 'redirect to home page with error message' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_url)
        expect(flash[:danger]).to eq I18n.t('users.login.required_login')
      end
    end

    xcontext 'when user has logged in'
  end
end
