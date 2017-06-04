ActiveAdmin.register Lease do

  before_create do |order|
    resource.admin_user = current_admin_user
  end

  scope :active, default: true
  scope :inactive
  
  config.clear_action_items!

  action_item :only => [:show] do
    link_to "Edit Lease", edit_admin_lease_path(resource)
  end

  belongs_to :unit, optional: true

  menu priority: 2

  permit_params :starts_on, :length_in_months, tenants_attributes: [:id, :full_name, :email, :mobile, :work_phone, :home_phone, :signee, :primary, :_destroy], charges_attributes: [:id, :name, :frequency, :amount]

  show do
    render 'show'
  end

  before_filter :active_lease, only: [:new]

  controller do
    def active_lease
      @unit = Unit.find(params[:unit_id])
      
      if @unit.has_active_lease?
        flash[:warning] = "Unit has an active lease."
      end
    end

    def build_new_resource
      return super if resource_params.first.present?
      charge = Charge.new(name: "Rent", frequency: 'monthly')
      Lease.new(charges: [charge])
    end

  end

  filter :ends_on, label: "Ends between:"
  filter :starts_on, label: "Starts between:"

  index do 
    column :unit do |f|
      link_to "#{f.unit.formatted_address}", admin_lease_path(f)
    end

    column "Started" do |f|
      f.starts_on
    end

    column "Ends in", sortable: :ends_on do |f|
      distance_of_time_in_words_to_now(f.ends_on)
    end

    column "Mo. Rent" do |f|
      number_to_currency(f.monthly_rent)
    end
  end

  form do |f|
    f.inputs name: "Details" do
      f.input :starts_on, label: "Lease starts on", as: :date_picker
      f.input :length_in_months, label: "Length", as: :select, collection: month_options
    end

    f.inputs name: "Tenants" do
      f.has_many :tenants do |f|
        f.input :full_name
        f.input :email
        f.input :mobile, as: :phone, input_html: { class: "phone_us" }
        f.input :work_phone, as: :phone, input_html: { class: "phone_us" }
        f.input :home_phone, as: :phone, input_html: { class: "phone_us" }
        f.input :signee, hint: "Check if the tenant has signed the contract."
        f.input :primary, hint: "Check if the tenant is the primary leasee."
      end
    end

    f.inputs name: "Charges" do
      f.has_many :charges do |f|
        f.input :name
        f.input :frequency, as: :select, collection: frequency_options
        f.input :amount, as: :number, input_html: { style: "width: 200px;" }
      end
    end

    f.actions
  end
    

end
