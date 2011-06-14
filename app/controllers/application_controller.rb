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
end
