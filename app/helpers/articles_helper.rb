module ArticlesHelper

  def article_link(article)
    link_to article.title, article_path(article), :title => article.title
  end

  def np_page_path(page_number, query = nil)
    if query.nil?
      articles_page_path(page_number)
    else
      search_path(query, :page => page_number)
    end
  end

end
