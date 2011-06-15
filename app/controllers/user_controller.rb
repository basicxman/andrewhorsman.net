class UserController < ApplicationController
  def login_form
    redirect_to root_path, :notice => "Already logged in as #{user.email}.  Feeling okay #{user.name}?" unless session[:user_id].nil?
  end

  def login
    user = User.find_by_email(params[:email])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to get_redirect, :notice => "Logged in as #{user.email}.  Hi #{user.name}!"
    else
      flash[:notice] = "Failed to login."
      render :login_form
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to root_path, :notice => "Logged out."
  end
end
