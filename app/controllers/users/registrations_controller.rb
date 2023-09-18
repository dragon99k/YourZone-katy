# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def create
    user = User.with_deleted.find_by(email: sign_up_params[:email])
    if user.present?
      self.resource = user
      resource.assign_attributes(sign_up_params)
      if resource.valid?
        resource.image = File.new("#{Rails.root}/public/images/default.jpg")
        resource.save
        resource.restore(recursive: true)

        sign_in(resource)

        redirect_to after_sign_in_path_for(resource)
      else
        clean_up_passwords resource
        flash[:notice] = flash[:notice].to_a.concat resource.errors.full_messages
        set_minimum_password_length

        # because resource persisted? so build new resource
        build_resource(sign_up_params)
        resource.save

        respond_with resource
      end
    else
      build_resource(sign_up_params)

      resource.image = File.new("#{Rails.root}/public/images/default.jpg")
      resource.save
      yield resource if block_given?
      if resource.persisted?
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          redirect_to new_user_session_path
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    end
  end
  
  private

  def sign_up_params
    birthday = params[:day].to_s + '-' + params[:month].to_s + '-' + params[:year].to_s
    params[:user][:birthday] = birthday

    params.require(:user).permit(:nickname, :email, :password, :password_confirmation, :sex, :residence, :birthday)
  end
end
