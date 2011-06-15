xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title get_config(:main_title)
    xml.description get_config(:main_tagline)
    xml.link articles_url
    xml.lastBuildDate @articles.first.published_at
    xml.pubDate @articles.first.published_at
    xml.managingEditor get_config(:owner_email)
    xml.webMaster get_config(:owner_email)
    xml.category get_config(:category)

    @articles.each do |article|
      xml.item do
        xml.title article.title
        xml.description article.content
        xml.link article_url(article)
        xml.pubDate article.published_at
      end
    end
  end
end
