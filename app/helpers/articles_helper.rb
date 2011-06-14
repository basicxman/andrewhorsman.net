module ArticlesHelper

  def article_link(article)
    link_to article.title, article_path(article), :title => article.title
  end

  def snip_content(content)
    content[0..get_config(:short_content_length)] + "..."
  end

end
