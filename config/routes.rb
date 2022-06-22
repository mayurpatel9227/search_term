Rails.application.routes.draw do
  root 'users#login_page'
  resources :friendships
  resources :users
  post "login", to:"users#login_user"
  post "add_friends", to:"users#add_friends"
  post "remove_friends", to:"users#remove_friends"
  get "search", to:"users#search"
  get "friends", to:"users#users_friends_list"
  get "users_list", to:"users#users_list"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
