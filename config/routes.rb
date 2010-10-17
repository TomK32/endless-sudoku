Wieners::Application.routes.draw do

  resources :boards do
    resources :sudokus
  end
  match '', :to => 'welcome#index'
  root :to => 'boards#show', :id => 1
end
