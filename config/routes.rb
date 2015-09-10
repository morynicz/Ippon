Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  resources :players do
    resources :participations
  end

  put '/participations/create_new/:player_id/:tournament_id' => 'participations#create_new', as: :create_new_participation

  root 'players#index'
  resources :tournaments do
    resources :locations
  end
  resources :ranks

  patch '/tournaments/:id/generate/:groups/:finals_no/:prefinals/:two_g/:three_g/:four_g' => 'tournaments#generate', as: :generate
  get '/calculate' => 'tournaments#calculate', as: :calculate
  get 'tournaments/:id/players' => 'tournaments#players', as: :tournament_players

  get '/fights/:id/edit' => 'fights#edit', as: :edit_fight
  patch 'fights/:id' => 'fights#update'

  get '/fights/:id' => 'fights#show', as: :fight
#  get '/players/:id/edit' => 'players#edit', as: :edit_player
#  patch '/players/:id' => 'players#update'



end
