# rails5 api + sqlite3 + multitenant

[Çalışma Videosu](https://youtu.be/q643tv3opmk)

```bash
$ rails new multitenant-api --api
$ rails generate model User name subdomain
$ rails generate model Project title
```

**app/model/user.rb**

```ruby
class User < ApplicationRecord
    validates :name, uniqueness: true    
    validates :subdomain, uniqueness: true    
    after_create :create_tenant
    private
    def create_tenant
      unless File.exists?("db/"+subdomain+".sqlite3")
        Apartment::Tenant.create(subdomain)
      end
    end
end
```

**app/controller/api/v1/projects_controller.rb**

```ruby
require 'domainatrix'
module Api
  module V1
    class ProjectsController < ApplicationController
      def index
        Apartment::Tenant.switch(Domainatrix.parse(request.referer).subdomain)
        projects = Project.order('created_at DESC');
        render json: { status: 'SUCCESS', message: "Load Project", data:projects}, status: :ok
      end
      def show
        Apartment::Tenant.switch(Domainatrix.parse(request.referer).subdomain)
        project = Project.find(params[:id])
        render json: { status: 'SUCCESS', message: "Load Project", data:project}, status: :ok
      end
      def create
        project = Project.new(project_params)

        if project.save
          render json: { status: 'SUCCESS', message: "Saved Project", data:project}, status: :ok
        else
          render json: { status: 'SUCCESS', message: "Project not saved", data:project_errors}, status: :unprocessable_entity
        end
      end
      private
        def project_params
          params.permit(:title)
        end
    end 
  end
end
```

**config/routes.rb**

```ruby
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
```

**db/seed.rb**

```ruby
User.create(name: "fa", subdomain: "fa")
User.create(name: "ali", subdomain: "ali")
User.create(name: "veli", subdomain: "veli")
```
