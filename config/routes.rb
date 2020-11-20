Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'offers#index'
  namespace :admin do
    resources :offers do
      put :update_status
    end
  end
end
