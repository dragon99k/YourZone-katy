# frozen_string_literal: true

class Admin::BaseController < ActionController::Base
  before_action :authenticate_admin!
  layout 'admin'
  DEFAULT_PER_PAGE = 20
end
