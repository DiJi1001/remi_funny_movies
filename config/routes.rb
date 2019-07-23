Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'movies#index'

  post '/login' => 'users#login'
  delete '/logout' => 'users#logout'
  get '/movies' => 'movies#index'
  get 'movies/share' => 'movies#new'
  post '/movies' => 'movies#create'
  post '/movies/comemnt' => 'movie_comments#create'
end
