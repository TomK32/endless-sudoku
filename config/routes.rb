Wieners::Application.routes.draw do
  resources :sudokus
  resources :boards
  match '', :to => 'welcome#index'
  root :to => 'boards#show', :id => 1
end
