Rails.application.routes.draw do


  scope 'api' do
    use_doorkeeper do
      skip_controllers :applications, :authorized_applications
    end
  end
  devise_for :users, controllers: {
           registrations: 'users/registrations',
  }

  scope :api, defaults: { format: 'json' } do
    resources :users, skip: [:create, :new, :edit, :update, :destroy] do
    end

    resources :appointments do
      get :available_slots, on: :collection
    end

    resources :time_slots do
    end
  end
end
