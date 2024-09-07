# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "up" => "rails/health#show", as: :rails_health_check
  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :accounts, only: %i[index create update]
    end
  end
end
