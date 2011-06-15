module ArticlesHelper

  def article_link(article)
    link_to article.title, article_path(article), :title => article.title
  end

end
