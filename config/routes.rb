Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }

  resources :sessions

  root to: "sessions#new", as: :root

  get "/connect_calendar", to: "calendars#redirect", as: "connect_calendar"
  get "/connect_calendar_callback", to: "calendars#callback", as: "connect_calendar_callback"
  get "/connect_zoom", to: "zoom#redirect", as: "connect_zoom"
  get "/connect_zoom_callback", to: "zoom#callback", as: "connect_zoom_callback"
end
