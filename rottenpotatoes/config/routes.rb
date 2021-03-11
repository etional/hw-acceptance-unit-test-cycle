Rottenpotatoes::Application.routes.draw do
  resources :movies
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
  
  get 'with_director/:title', to: 'movies#search', as: 'search_movies'
end
