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
