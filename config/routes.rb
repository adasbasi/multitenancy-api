Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  constraints :subdomain => 'api' do
    namespace :api, path: nil do
      namespace :v1 do
        resources :projects
      end
    end
  end
  
  namespace :api, path: nil do
    namespace :v1, path: nil do
      resources :projects
    end
  end
end
