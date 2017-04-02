Rails.application.routes.draw do
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  get 'clubs/admin/any' => 'clubs#is_admin_for_any'
  get 'clubs/admin/:id' => 'clubs#is_admin'
  get 'clubs/admin' => 'clubs#where_admin'
  resources :clubs, only: [:index, :show, :create, :update, :destroy]
  get 'clubs/:id/admins' => 'clubs#admins'
  post 'clubs/:id/admins/:user_id' => 'clubs#add_admin'
  delete 'clubs/:id/admins/:user_id' => 'clubs#delete_admin'
  get 'clubs/:id/players' => 'clubs#players'

  resources :tournaments, only: [:show, :create, :index, :update, :destroy] do
    resources :groups, only: [:create, :index]
    resources :playoff_fights, only: [:create, :index]
    resources :teams, only: [:index, :create]
  end

  resources :groups, only: [:show, :update, :destroy] do
    resources :group_fights, only: [:index, :create]
  end

  resources :group_fights, only: [:show, :update, :destroy]
  resources :playoff_fights, only: [:show, :update, :destroy]

  get 'tournaments/:id/admins' => 'tournaments#admins'
  post 'tournaments/:id/admins/:user_id' => 'tournaments#add_admin'
  delete 'tournaments/:id/admins/:user_id' => 'tournaments#delete_admin'
  get 'tournaments/:id/participants' => 'tournaments#participants'
  get 'tournaments/:id/participants/unassigned' => 'tournaments#unassigned_participants'
  post 'tournaments/:id/participants/:player_id' => 'tournaments#add_participant'
  delete 'tournaments/:id/participants/:player_id' => 'tournaments#delete_participant'

  resources :teams, only: [:show, :update, :destroy]
  put 'teams/:id/add_member/:player_id' => 'teams#add_member'
  delete 'teams/:id/delete_member/:player_id' => 'teams#delete_member'
  resources :players

  resources :fights, only: [:show, :create, :update, :destroy]

  resources :points, only: [:show, :create, :update, :destroy]
  resources :team_fights, only: [:show, :create, :update, :destroy]
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
end
