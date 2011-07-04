def article
  $a = Article.create({
    :published_at => Time.zone.now,
    :last_commit_date => Time.zone.now,
    :stage => 3,
    :author => "John Smith"
  }.merge(yield))
end

def add_tags(*list)
  list.each do |t|
    $a.tags << Tag.find_or_create_by_keyword(t)
  end
end
#--------------------------------------

User.create(:email => "self@andrewhorsman.net", :name => "Andrew Horsman", :password => "testing")
User.create(:email => "test@andrewhorsman.net", :name => "John Smith",     :password => "testing")

article do
  {
    :title => "Unique article",
    :content => "Entirely unique content."
  }
end

35.times do |n|
  article do
    {
      :title => "Some common article",
      :content => "Common content in article ##{n}",
      :published_at => Time.zone.now + n.hours,
      :updated_at => Time.zone.now + n.hours
    }
  end
end
