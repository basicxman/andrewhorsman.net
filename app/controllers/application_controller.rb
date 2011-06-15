class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

  # Shorter, more-readable versions of @sym = value, respond_with @sym
  def expose(sym, value = nil)
    set(sym, value)
    respond_with instance_variable_get(:"@#{sym}")
  end
  
  def set(sym, value)
    instance_variable_set(:"@#{sym}", value) unless value.nil?
  end

  # Redirect or render is a frequently used pattern.
  def redirect_or_render(redirect_path, render_action)
    if yield
      redirect_to(redirect_path)
    else
      render(render_action)
    end
  end

  # User authentication
  def user
    @user = User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :user # Available in views too!

  def authenticate_admin
    redirect_to root_path, :notice => "Need to be an admin to see this page!" if user.nil? or !user.is_admin
  end

  def authenticate_user
    redirect_to login_path, :notice => "Need to be logged in to see this page!" if user.nil?
  end
end
