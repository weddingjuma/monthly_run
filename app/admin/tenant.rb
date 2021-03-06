ActiveAdmin.register Tenant do

  before_create do |order|
    resource.admin_user = current_admin_user
  end

  config.clear_action_items!
  
  scope :active, default: true
  scope :inactive

  menu priority: 3

  filter :units
  filter :first_name
  filter :last_name
  filter :email
  filter :mobile
  filter :primary

  index do 
    column "Full Name" do |f|
      link_to "#{f.full_name}", admin_tenant_path(f)
    end

    column "Email" do |f|
      f.email
    end

    column "Mobile" do |f|
      f.mobile
    end

    column "Leased Unit" do |f|
      f.rented_address
    end
  end

end
