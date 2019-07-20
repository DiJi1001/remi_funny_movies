describe 'routes', type: :routing do
  describe 'route for home page' do
    specify do
      expect(get('/')).to route_to('movies#index')
    end
  end

  describe 'routes for users', :aggregate_failures do
    specify do
      expect(post('/login')).to route_to('users#login')
      expect(delete('/logout')).to route_to('users#logout')
    end
  end

  describe 'routes for movies', :aggregate_failures do
    specify do
      expect(get('/movies')).to route_to('movies#index')
      expect(get('/movies/share')).to route_to('movies#new')
      expect(post('/movies')).to route_to('movies#create')
    end
  end
end
