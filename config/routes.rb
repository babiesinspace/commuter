Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :commutes
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "commutes#landing"
end
