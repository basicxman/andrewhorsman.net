ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  def get_config(sym)
    Site::Application.config.send(sym)
  end
end

class << ActiveSupport::TestCase
  def add_users
    [Factory(:user), Factory(:user, :email => "foo@bar.com", :is_admin => false)]
  end
  
  def delete_users
    User.all.each { |u| u.destroy }
  end
  
  def add_articles
    21.times.to_a.inject([]) { |a| a << Factory(:article) }
  end

  def delete_articles
    Article.all.each { |a| a.destroy }
  end
end
