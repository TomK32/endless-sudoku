Wieners::Application.routes.draw do
  resources :sudokus, :only => [ :show ]

  root :to => 'welcome#index'
end
