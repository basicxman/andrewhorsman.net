ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  def get_config(sym)
    Site::Application.config.send(sym)
  end

  def login_as_admin
    login(:admin)
  end

  def login_as_user
    login(:user)
  end

  def login(factory_symbol)
    user = Factory(factory_symbol)
    session[:user_id] = user.id
    user.id
  end
end
