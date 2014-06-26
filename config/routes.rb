Rails.application.routes.draw do

  resources :food_trucks, only: [:index, :show] do
    resources :reviews, only: [:create, :new, :destroy, :edit, :update]
  end

  devise_for :users

  root to: "food_trucks#index"

end
