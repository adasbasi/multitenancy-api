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
