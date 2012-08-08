require "rails_admin/application_controller"

module RailsAdmin
  class ApplicationController < ::ApplicationController
    filter_access_to :all
  end
end
# RailsAdmin config file. Generated on May 08, 2012 18:57
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|

  # If your default_local is different from :en, uncomment the following 2 lines and set your default locale here:
  # require 'i18n'
  # I18n.default_locale = :de

  config.current_user_method { current_user } # auto-generated

  # If you want to track changes on your models:
  # config.audit_with :history, User

  # Or with a PaperTrail: (you need to install it first)
  config.audit_with :paper_trail, User

  # Set the admin name here (optional second array element will appear in a beautiful RailsAdmin red ©)
  config.main_app_name = ['Copper', 'Admin']
  # or for a dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }


  #  ==> Global show view settings
  # Display empty fields in show views
  config.compact_show_view = false

  #  ==> Global list view settings
  # Number of default rows per-page:
  # config.default_items_per_page = 20

  #  ==> Included models
  # Add all excluded models here:
  # config.excluded_models = [Check, Identities::Facebook, Identities::Flickr, Identities::Github, Identities::Google, Identities::Soundcloud, Identities::Tumblr, Identities::Twitter, Identities::Vimeo, Identities::Youtube, Identity, Order, Page, Role, Tip, User]


  # Add models here if you want to go 'whitelist mode':
  # config.included_models = [Check, Identities::Facebook, Identities::Flickr, Identities::Github, Identities::Google, Identities::Soundcloud, Identities::Tumblr, Identities::Twitter, Identities::Vimeo, Identities::Youtube, Identity, Order, Page, Role, Tip, User]
  config.included_models = [Check, Identity, Order, Page, Tip, User]

  config.models do
    edit do
      fields do
        visible do
          visible && !read_only
        end
      end
    end
  end


  # Application wide tried label methods for models' instances
  # config.label_methods << :description # Default is [:name, :title]

  #  ==> Global models configuration
  # config.models do
  #   # Configuration here will affect all included models in all scopes, handle with care!
  #
  #   list do
  #     # Configuration here will affect all included models in list sections (same for show, export, edit, update, create)
  #
  #     fields_of_type :date do
  #       # Configuration here will affect all date fields, in the list section, for all included models. See README for a comprehensive type list.
  #     end
  #   end
  # end
  #
  #  ==> Model specific configuration
  # Keep in mind that *all* configuration blocks are optional.
  # RailsAdmin will try his best to provide the best defaults for each section, for each field.
  # Try to override as few things as possible, in the most generic way. Try to avoid setting labels for models and attributes, use ActiveRecord I18n API instead.
  # Less code is better code!
  # config.model MyModel do
  #   # Cross-section field configuration
  #   object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #   label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #   label_plural 'My models'      # Same, plural
  #   weight -1                     # Navigation priority. Bigger is higher.
  #   parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #   navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  #   # Section specific configuration:
  #   list do
  #     filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #     items_per_page 100    # Override default_items_per_page
  #     sort_by :id           # Sort column (default is primary key)
  #     sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     # Here goes the fields configuration for the list view
  #   end
  # end

  # Your model's configuration, to help you get started:

  # All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible. (visible(true))

  # config.model Check do
  #   # Found associations:
  #     configure :user, :belongs_to_association
  #     configure :tips, :has_many_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :user_id, :integer         # Hidden
  #     configure :check_state, :string
  #     configure :count, :integer
  #     configure :number, :integer
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Identities::Facebook do
  #   # Found associations:
  #     configure :user, :belongs_to_association
  #     configure :pages, :has_many_association
  #     configure :tips, :has_many_association
  #     configure :checks, :has_many_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :provider, :string
  #     configure :uid, :string
  #     configure :username, :string
  #     configure :name, :string
  #     configure :email, :string
  #     configure :image, :string
  #     configure :location, :string
  #     configure :phone, :string
  #     configure :urls, :string
  #     configure :token, :string
  #     configure :secret, :string
  #     configure :type, :string
  #     configure :identity_state, :string
  #     configure :message, :datetime
  #     configure :user_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Identities::Flickr do
  #   # Found associations:
  #     configure :user, :belongs_to_association
  #     configure :pages, :has_many_association
  #     configure :tips, :has_many_association
  #     configure :checks, :has_many_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :provider, :string
  #     configure :uid, :string
  #     configure :username, :string
  #     configure :name, :string
  #     configure :email, :string
  #     configure :image, :string
  #     configure :location, :string
  #     configure :phone, :string
  #     configure :urls, :string
  #     configure :token, :string
  #     configure :secret, :string
  #     configure :type, :string
  #     configure :identity_state, :string
  #     configure :message, :datetime
  #     configure :user_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Identities::Github do
  #   # Found associations:
  #     configure :user, :belongs_to_association
  #     configure :pages, :has_many_association
  #     configure :tips, :has_many_association
  #     configure :checks, :has_many_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :provider, :string
  #     configure :uid, :string
  #     configure :username, :string
  #     configure :name, :string
  #     configure :email, :string
  #     configure :image, :string
  #     configure :location, :string
  #     configure :phone, :string
  #     configure :urls, :string
  #     configure :token, :string
  #     configure :secret, :string
  #     configure :type, :string
  #     configure :identity_state, :string
  #     configure :message, :datetime
  #     configure :user_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Identities::Google do
  #   # Found associations:
  #     configure :user, :belongs_to_association
  #     configure :pages, :has_many_association
  #     configure :tips, :has_many_association
  #     configure :checks, :has_many_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :provider, :string
  #     configure :uid, :string
  #     configure :username, :string
  #     configure :name, :string
  #     configure :email, :string
  #     configure :image, :string
  #     configure :location, :string
  #     configure :phone, :string
  #     configure :urls, :string
  #     configure :token, :string
  #     configure :secret, :string
  #     configure :type, :string
  #     configure :identity_state, :string
  #     configure :message, :datetime
  #     configure :user_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Identities::Soundcloud do
  #   # Found associations:
  #     configure :user, :belongs_to_association
  #     configure :pages, :has_many_association
  #     configure :tips, :has_many_association
  #     configure :checks, :has_many_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :provider, :string
  #     configure :uid, :string
  #     configure :username, :string
  #     configure :name, :string
  #     configure :email, :string
  #     configure :image, :string
  #     configure :location, :string
  #     configure :phone, :string
  #     configure :urls, :string
  #     configure :token, :string
  #     configure :secret, :string
  #     configure :type, :string
  #     configure :identity_state, :string
  #     configure :message, :datetime
  #     configure :user_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Identities::Tumblr do
  #   # Found associations:
  #     configure :user, :belongs_to_association
  #     configure :pages, :has_many_association
  #     configure :tips, :has_many_association
  #     configure :checks, :has_many_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :provider, :string
  #     configure :uid, :string
  #     configure :username, :string
  #     configure :name, :string
  #     configure :email, :string
  #     configure :image, :string
  #     configure :location, :string
  #     configure :phone, :string
  #     configure :urls, :string
  #     configure :token, :string
  #     configure :secret, :string
  #     configure :type, :string
  #     configure :identity_state, :string
  #     configure :message, :datetime
  #     configure :user_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Identities::Twitter do
  #   # Found associations:
  #     configure :user, :belongs_to_association
  #     configure :pages, :has_many_association
  #     configure :tips, :has_many_association
  #     configure :checks, :has_many_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :provider, :string
  #     configure :uid, :string
  #     configure :username, :string
  #     configure :name, :string
  #     configure :email, :string
  #     configure :image, :string
  #     configure :location, :string
  #     configure :phone, :string
  #     configure :urls, :string
  #     configure :token, :string
  #     configure :secret, :string
  #     configure :type, :string
  #     configure :identity_state, :string
  #     configure :message, :datetime
  #     configure :user_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Identities::Vimeo do
  #   # Found associations:
  #     configure :user, :belongs_to_association
  #     configure :pages, :has_many_association
  #     configure :tips, :has_many_association
  #     configure :checks, :has_many_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :provider, :string
  #     configure :uid, :string
  #     configure :username, :string
  #     configure :name, :string
  #     configure :email, :string
  #     configure :image, :string
  #     configure :location, :string
  #     configure :phone, :string
  #     configure :urls, :string
  #     configure :token, :string
  #     configure :secret, :string
  #     configure :type, :string
  #     configure :identity_state, :string
  #     configure :message, :datetime
  #     configure :user_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Identities::Youtube do
  #   # Found associations:
  #     configure :user, :belongs_to_association
  #     configure :pages, :has_many_association
  #     configure :tips, :has_many_association
  #     configure :checks, :has_many_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :provider, :string
  #     configure :uid, :string
  #     configure :username, :string
  #     configure :name, :string
  #     configure :email, :string
  #     configure :image, :string
  #     configure :location, :string
  #     configure :phone, :string
  #     configure :urls, :string
  #     configure :token, :string
  #     configure :secret, :string
  #     configure :type, :string
  #     configure :identity_state, :string
  #     configure :message, :datetime
  #     configure :user_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Identity do
  #    # Found associations:
  #      configure :user, :belongs_to_association
  #      configure :pages, :has_many_association
  #      configure :tips, :has_many_association
  #      configure :checks, :has_many_association   #   # Found columns:
  #      configure :id, :integer
  #      configure :provider, :string
  #      configure :uid, :string
  #      configure :username, :string
  #      configure :name, :string
  #      configure :email, :string
  #      configure :image, :string
  #      configure :location, :string
  #      configure :phone, :string
  #      configure :urls, :string
  #      configure :type, :string
  #      configure :identity_state, :string
  #      configure :message, :datetime
  #      configure :user_id, :integer         # Hidden
  #      configure :created_at, :datetime
  #      configure :updated_at, :datetime   #   # Sections:
  #    list do; end
  #    export do; end
  #    show do; end
  #    edit do; end
  #    create do; end
  #    update do; end
  #  end
  # config.model Order do
  #   # Found associations:
  #     configure :user, :belongs_to_association
  #     configure :tips, :has_many_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :user_id, :integer         # Hidden
  #     configure :state, :string
  #     configure :charge_token, :string
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Page do
  #   # Found associations:
  #     configure :identity, :belongs_to_association
  #     configure :tips, :has_many_association
  #     configure :checks, :has_many_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :title, :string
  #     configure :url, :string
  #     configure :author_state, :string
  #     configure :identity_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Role do
  #   # Found associations:
  #     configure :users, :has_and_belongs_to_many_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :name, :string
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Tip do
  #   # Found associations:
  #     configure :order, :belongs_to_association
  #     configure :check, :belongs_to_association
  #     configure :page, :belongs_to_association
  #     configure :user, :has_one_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :order_id, :integer         # Hidden
  #     configure :check_id, :integer         # Hidden
  #     configure :page_id, :integer         # Hidden
  #     configure :amount_in_cents, :integer
  #     configure :paid_state, :string
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model User do
  #   # Found associations:
  #     configure :identities, :has_many_association
  #     configure :orders, :has_many_association
  #     configure :tips, :has_many_association
  #     configure :checks, :has_many_association
  #     configure :roles, :has_and_belongs_to_many_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :name, :string
  #     configure :tip_preference_in_cents, :integer
  #     configure :email, :string
  #     configure :stripe_id, :string
  #     configure :accept_terms, :boolean
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
end
