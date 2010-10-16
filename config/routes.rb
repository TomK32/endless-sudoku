Wieners::Application.routes.draw do
  resources :sudokus, :only => [ :show ]
  resources :boards
  root :to => 'welcome#index'
end
