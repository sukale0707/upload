Rails.application.routes.draw do
  root :to => "uploads#index"
  get 'uploads/index'
  post 'uploads/create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
