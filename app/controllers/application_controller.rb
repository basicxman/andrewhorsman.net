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
    if user.nil? or !user.is_admin
      set_redirect
      redirect_to login_form_path, :notice => "Need to be an admin to see this page!"
    end
  end

  def authenticate_user
    if user.nil?
      set_redirect
      redirect_to login_form_path, :notice => "Need to be logged in to see this page!"
    end
  end

  def set_redirect
    session[:redirect_to] = request.fullpath
  end

  def get_redirect
    r = session[:redirect_to] || root_path
    session[:redirect_to] = nil
    r
  end

  # Sidebar
  def render_sidebar_widget(path, item = nil)
    locals = {}
    locals = self.send(item) unless item.nil?
    render_to_string(:partial => path, :locals => locals).html_safe
  end
  helper_method :render_sidebar_widget

  def reading_list
    set(:reading_items, ReadingItem.updated_desc.all)
    { :reading_items => @reading_items }
  end
end
