xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.title get_config(:main_title) + " Reading List"
  xml.description "Official recommended reading list of get_config(:main_title)"
  xml.link reading_list_url
  xml.lastBuildDate @reading_items.first.updated_at
  xml.pubDate @reading_items.first.updated_at
  xml.managingEditor get_config(:owner_email)
  xml.webMaster get_config(:owner_email)
  xml.category get_config(:category)

  @reading_items.each do |item|
    xml.item do
      xml.title item.name
      xml.description item.name
      xml.link item.link
      xml.pubDate item.updated_at
    end
  end
end
