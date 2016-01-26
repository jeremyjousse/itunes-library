ItunesLibrary::Application.routes.draw do
  root 'home#index'

  namespace :api, defaults: { format: 'json' } do
    resources :itunes_tracks
    resources :wanted_tracks
  end

  get :itunes_play, controller: 'application'
  get :itunes_previous, controller: 'application'
  get :itunes_next, controller: 'application'
  get :update_library, controller: 'application'
  get :update_all_ratings, controller: 'application'

  resources :wanted_tracks do
    get :search_file
    get :set_found
    get :new_listing, on: :collection
    patch :update_wanted_tracks_found_in_myfreemp3, on: :collection
    patch :purge, on: :collection
    post :new_listing_add, on: :collection
    get :new_import, on: :collection
    post :new_import_select, on: :collection
    post :new_import_add, on: :collection
  end

  resources :itunes_tracks do
    get :show_cover
    get :easy_complet, on: :collection
    post :easy_update
    get :easy_update_skeep
    get :edit_now_playing, on: :collection
    get :update_missing_informations, on: :collection
    post :rate, on: :member
    patch :update_cover
    post :update_from_reference
    get :update_cover_from_reference
    get :update_references
    get :update_waiting_references, on: :collection
  end

  resources :mp3_importers do
    get :index
  end

  get 'mp3_importers/:file/edit' => 'mp3_importers#edit',
      constraints: { file: /[^\/]+/ }, as: :edit_mp3

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
