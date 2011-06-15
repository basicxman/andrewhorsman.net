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
    $a.tags << Tag.find_or_create(t)
  end
end
#--------------------------------------


article do
  {
    :title => "Testing",
    :content => "Testing a new page."
  }
end
add_tags "foo", "bar"

30.times do |n|
  article do
    {
      :title => "Article #{n} in series",
      :content => "This is part of a series (except not really of course) zomg!"
    }
  end
  add_tags "foo", "series"
end

article do
  {
    :title => "Long form article",
    :content => File.read(File.join(Dir.pwd, "doc/lipsum.txt"))
  }
end
add_tags "foo", "some-very-very-very-very-long-tag"
