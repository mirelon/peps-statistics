Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  post 'api/performance' => 'api#add_performance'
  match 'api/performance', to: 'api#options_add_performance', via: [:options]
  get 'api/download_performances' => 'api#download_performances'
end
