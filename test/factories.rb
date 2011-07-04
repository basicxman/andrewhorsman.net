Factory.define :article do |f|
  f.sequence(:title) { |n| "Foo #{n}" }
  f.sequence(:published_at) { |n| Time.zone.now + n.minutes }

  f.author  "John Smith"
  f.content "Lipsum"
  f.stage   3
  f.last_commit_date Time.zone.now
end

Factory.define :tag do |f|
  f.sequence(:keyword) { |n| "foo-#{n}" }
end

Factory.define :reading_item do |f|
  f.link "http://andrewhorsman.net"
  f.name "Andrew Horsman"
  f.rating 10
end

Factory.define :admin, :class => User do |f|
  f.email    "self@andrewhorsman.net"
  f.name     "Andrew Horsman"
  f.password "testing"
  f.is_admin true
end

Factory.define :user do |f|
  f.email    "foo@bar.com"
  f.name     "John Smith"
  f.password "testing"
end
