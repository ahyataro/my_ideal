Rails.application.routes.draw do
  devise_for :users
  resource :ideal, only: [:edit, :update]
  root 'ideals#edit'
end
