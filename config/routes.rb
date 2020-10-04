Rails.application.routes.draw do
  mount Notifications::Engine => "/notifications"
  resources :custom_trips, only: [:create, :new]

  mount Crono::Web, at: '/crono'
  get 'messages/index'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :tours, except: [:edit, :update] do
    resources :tour_details, only: [:create, :update, :destroy]
    resources :bookings, only: [:create, :destroy]
    resources :tour_reviews, only: [:create, :destroy]
  end

  resources :blogs
  resources :locations
  get '/card/new' => 'bookings#new_card', as: :add_payment_method
  post "/card" => "bookings#create_card", as: :create_payment_method
  get '/success' => 'bookings#success', as: :success

  resources :hotels do
    resources :hotel_rooms, except: [:index]
    resources :hotel_reviews, only: [:create, :destroy]
  end
  resources :car_rentals do
    resources :vehicles
  end
  resources :car_rental_owners do
    get :my_car_rentals
  end
  resources :trip_organizers do
    get :my_tours
  end
  resources :hotel_managers do
    get :my_hotels
  end


  resources :conversations, only: [:create] do
    member do
      post :close
    end
  end



  get 'charges/:id', to: 'charges#new', as: :new_charge
  post 'charges/:id', to: 'charges#create', as: :charges

  get 'featured_charges/:id', to: 'featured_charges#new', as: :new_featured_charge
  post 'featured_charges/:id', to: 'featured_charges#create', as: :featured_create

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  resources :contact, only: [:index]
  resources :about, only: [:index]
  resources :posts do
    post 'delete_image_attachment/:id', to: 'posts#delete_image_attachment', as: :delete_image_attachment
  end

  resources :comments, only: [:create, :destroy]
  resources :users do
    member do
      get :friends
      get :followers
      get :deactivate
      get :mentionable
    end
  end
  get '/my_bookings/:id', to: 'users#my_bookings', as: :my_bookings
  resources :events, except: [:edit, :update]


    get '/feed', to:  'feed#index'

    get '/feed/front', as: "home"


  match :follow, to: 'follows#create', as: :follow, via: :post
  match :unfollow, to: 'follows#destroy', as: :unfollow, via: :post
  match :like, to: 'likes#create', as: :like, via: :post
  match :unlike, to: 'likes#destroy', as: :unlike, via: :post
  match :find_friends, to: 'feed#find_friends', as: :find_friends, via: :get
  match :about, to: 'feed#about', as: :about, via: :get




  namespace :api do
    resources :tours, only: [:index, :create, :update, :destroy, :show]

    resource :users, only: [:show]
    resource :trip_organizers, only: [:create, :show, :destroy, :update, :index]
    resource :tour_details, only: [:update, :show, :destroy]
    resource :bookings, only: [:create, :destroy, :show]
      devise_for :users, as: 'api', controllers: {
          session: 'api/sessions', registrations: 'api/users/registrations'}, skip: [:password]
  end


  namespace :dashboard do
    resources :trip_organizers, only: [:index, :update]
    resources :tours, only: [:destroy, :create, :edit ,:update] do
      resources :tour_details, only: [:index, :update]
      resources :featured_tours
    end

    resources :hotel_managers, only: [:update, :index]
    resources :hotels, only: [:destroy, :create, :update, :edit] do
      resources :hotel_rooms, only: [:index, :update, :create, :new, :index]
      resources :featured_hotels, only: [:new, :create]
    end

    resources :car_rental_owners, only: [:update, :index]
    resources :car_rentals, only: [:destroy, :create, :update, :edit] do
      resources :vehicles, only: [:index, :update, :create, :new, :index]
    end
  end
end
