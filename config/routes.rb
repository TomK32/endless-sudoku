Wieners::Application.routes.draw do

  devise_for :users
  resources :users
  resources :boards do
    resources :sudokus
  end
  match '', :to => 'welcome#index'
  root :to => 'boards#show', :id => 1
end
