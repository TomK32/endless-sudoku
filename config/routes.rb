Wieners::Application.routes.draw do
  resources :sudokus, :only => [ :show ]
  resources :boards
  root :to => 'boards#show', :id => 1
end
