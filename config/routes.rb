Wieners::Application.routes.draw do

  devise_for :users
  resources :users
  resources :boards do
    resources :sudokus
  end
  match 'pages/:action', :controller => 'pages'
  root :to => 'welcome#index'
end
