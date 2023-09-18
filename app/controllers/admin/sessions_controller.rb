# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController
  layout 'login_admin'

  def create
    self.resource = warden.authenticate!(auth_options)
    if resource.admin?
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
    else
      set_flash_message!(:alert, :invalid)
      sign_out(resource_name)
      return redirect_to new_admin_session_path
    end
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  def destroy
    signed_out = sign_out(resource_name)
    set_flash_message! :notice, :signed_out if signed_out
    yield if block_given?
    respond_to_on_destroy
  end

  private

  def after_sign_out_path_for(_resource_or_scope)
    new_admin_session_path
  end

  def after_sign_in_path_for(_resource)
    admin_root_path
  end
end
