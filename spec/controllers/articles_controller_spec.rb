require 'spec_helper'

describe ArticlesController do
  before(:all) do
    21.times do
      Factory(:article)
    end
  end

  it "should get the articles index and display x number of articles" do
    visit articles_path
    response.should be_success
    page.should have_selector(".article-title", :count => get_config(:articles_in_page))
  end

end
