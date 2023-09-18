# frozen_string_literal: true

class Admin::RegistrationsController < Devise::RegistrationsController
  layout 'admin'

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)


    update_resource(resource, account_update_params)

    yield resource if block_given?

    if account_update_params[:password] == account_update_params[:password_confirmation]
      resource.assign_attributes(account_update_params)

      if resource.valid?
        resource.save
        redirect_to edit_admin_registration_path
      else
        clean_up_passwords resource
        set_minimum_password_length
        render :edit
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      render :edit
    end
  end
end
