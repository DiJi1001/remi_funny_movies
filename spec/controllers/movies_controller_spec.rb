RSpec.describe MoviesController do
  describe 'GET: /movies' do
    let(:user) { create :user }

    before { create_list :movie, 5, user_id: user.id }

    context 'when does not pass page param' do
      before { get :index }

      it 'render the movie index page with the list of movies', :aggregate_failures do
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
        expect(assigns(:movies)).to eq Movies::Fetch.new.execute
      end
    end

    context 'when does not pass page param' do
      before { get :index, params: { page: 2 } }

      it 'render the movie index page with the list of movies', :aggregate_failures do
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
        expect(assigns(:movies)).to eq Movies::Fetch.new(2).execute
      end
    end
  end

  describe 'GET: /movies/share' do
    context 'when user does not login yet' do
      before { get :new }

      it 'redirect to home page with error message', :aggregate_failures do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_url)
        expect(flash[:danger]).to eq I18n.t('users.login.required_login')
      end
    end

    context 'when user has logged in' do
      let(:user) { create :user }

      before do
        session[:user_id] = user.id
        get :new
      end

      it 'render the sharing movie page', :aggregate_failures do
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'POST: /movies' do
    context 'when user does not login yet' do
      before { post :create }

      it 'redirect to home page with error message', :aggregate_failures do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_url)
        expect(flash[:danger]).to eq I18n.t('users.login.required_login')
      end
    end

    context 'when user has logged in' do
      let(:user) { create :user }
      let(:youtube_url) { 'youtube_url' }
      let(:error_message) { 'error_message' }
      let(:service) { Movies::Share.new(user, youtube_url) }

      before { session[:user_id] = user.id }

      context 'when sharing movie fails' do
        before do
          allow(Movies::Share).to receive(:new).with(user, youtube_url).and_return(service)
          allow_any_instance_of(Movies::Share).to receive(:execute).and_return(false)
          allow_any_instance_of(Movies::Share).to receive(:error_message).and_return(error_message)
          post :create, params: { youtube_url: youtube_url }
        end

        it 'render the sharing movie page with the error message', :aggregate_failures do
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:new)
          expect(flash[:danger]).to eq error_message
        end
      end

      context 'when sharing movie is successfully' do
        before do
          allow(Movies::Share).to receive(:new).with(user, youtube_url).and_return(service)
          allow_any_instance_of(Movies::Share).to receive(:execute).and_return(true)
          allow_any_instance_of(Movies::Share).to receive(:error_message)
          post :create, params: { youtube_url: youtube_url }
        end

        it 'render the sharing movie page with the error message', :aggregate_failures do
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(root_url)
          expect(flash[:success]).to eq I18n.t('movies.sharing.share_successfully')
        end
      end
    end
  end
end
