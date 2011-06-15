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
    :content => <<-eof
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed augue erat, viverra ac aliquam non, suscipit ac urna. Pellentesque varius dictum quam vitae dignissim. Nam nec sapien at lacus vestibulum facilisis nec et metus. Fusce eu lacus et nulla congue blandit. Nulla aliquam placerat placerat. Quisque tempor, augue vitae scelerisque cursus, metus nulla dignissim est, non tempor libero nunc ac tellus. Aenean suscipit sodales nisi eget hendrerit. Suspendisse pellentesque sodales ligula a fermentum. Quisque posuere mauris non ante commodo pulvinar. Duis in magna a dui auctor volutpat a quis ligula. In sagittis rhoncus volutpat. Morbi tempus mauris pellentesque purus faucibus rutrum. Proin placerat nunc a nulla tristique ultricies. Nam arcu quam, bibendum a tempus at, tempus vel eros. Fusce quis ipsum felis, et luctus libero. Vivamus rhoncus vulputate pretium. Curabitur enim tortor, ultrices eu varius ut, luctus eu diam. Nam ac nisl nec eros tincidunt vehicula. Fusce ultrices porttitor justo. Donec id diam eget augue mattis feugiat.

Cras at nisi id velit mattis sodales. Morbi ut nunc sed dolor commodo viverra. Morbi suscipit lacinia lacus semper tempor. Ut hendrerit fringilla tincidunt. Nullam ac quam id orci ultrices porta. Phasellus fringilla ante erat. Ut a sapien erat. Etiam et justo in est posuere elementum. Donec placerat nunc vitae lacus laoreet fermentum. Etiam in risus mi, sit amet lacinia nisi. Curabitur mi risus, tincidunt quis rutrum quis, fermentum at justo. Nulla tincidunt, eros congue laoreet ullamcorper, ipsum elit pellentesque tortor, a faucibus leo enim ac diam. Curabitur suscipit ultrices sapien sed semper. Vivamus ac iaculis quam. Phasellus vel neque ut leo varius commodo.

Sed molestie, lacus et iaculis vestibulum, nulla quam ullamcorper libero, non porta ligula nisl ac lorem. Nulla lectus orci, egestas eget dictum et, congue ac nisl. Donec vitae risus ac magna convallis lobortis at a arcu. Nam quis hendrerit nibh. Fusce ultricies nibh eu elit tincidunt vel suscipit risus iaculis. Nunc tincidunt facilisis iaculis. Ut ligula sem, auctor in condimentum sit amet, semper vel magna. Sed odio augue, mattis ac convallis a, tincidunt ut lacus. Curabitur elementum cursus ultricies. Quisque auctor mollis dolor, vel vehicula ante laoreet in. Praesent dignissim scelerisque leo, eu tristique velit dignissim sed. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla faucibus justo sit amet neque aliquam accumsan. Duis fermentum imperdiet blandit. Ut tempus varius est, a sagittis diam mollis vitae. Donec quis egestas est.

Praesent euismod scelerisque ligula quis luctus. Curabitur id tellus quis quam laoreet ultricies. In euismod mi sit amet libero vestibulum consectetur. Morbi cursus gravida sapien, sit amet blandit neque euismod a. Vivamus magna tortor, feugiat et accumsan blandit, imperdiet ut metus. Praesent viverra posuere est, id sollicitudin leo ultrices aliquet. Phasellus et arcu nulla. Duis eu magna nibh. Nunc magna diam, vehicula vitae porta eget, elementum in lacus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Aliquam blandit aliquet neque sed pretium. Praesent feugiat hendrerit blandit. Quisque id odio felis. Mauris vehicula sagittis nulla, vitae pharetra erat laoreet eu. Nullam vitae nulla convallis quam tincidunt sollicitudin. Nunc tortor mi, venenatis a varius sit amet, ultricies sit amet dolor. Integer elit nibh, pretium ac eleifend at, ullamcorper at tortor.

Cras quam lacus, adipiscing id sollicitudin et, ultricies imperdiet tellus. In a est metus. Sed nec interdum nisi. Ut in magna sed odio ultricies placerat. Fusce vestibulum, eros ut rhoncus aliquam, tortor erat tincidunt libero, non consectetur dui nunc sollicitudin libero. Duis ac magna sed odio eleifend luctus et in velit. Vivamus in diam gravida urna eleifend ultrices ut ut velit. Curabitur elementum nisi tristique augue rhoncus ornare. Aenean cursus, velit quis feugiat tristique, velit ante ultricies metus, ac ultrices dolor diam a ante. Integer in tellus lacus, in laoreet metus. Duis et quam mollis dolor interdum commodo. Nam ut tellus nec lectus dignissim luctus ac id justo. Morbi at placerat magna. Pellentesque semper molestie sapien. Nulla rhoncus, lorem non porta sagittis, elit eros aliquam nisl, at dapibus risus nisi sit amet sem. Praesent et odio sed lacus congue feugiat at fringilla eros.

Phasellus gravida, turpis vel bibendum ultricies, enim augue vehicula diam, eu varius urna orci vitae magna. Maecenas in ligula magna. Quisque leo ante, tristique nec pulvinar nec, convallis vel orci. Nunc non eros a dolor congue viverra bibendum sed mauris. Nam id justo eu tellus vulputate faucibus. Aenean volutpat dui vitae dolor aliquet viverra. Nulla porta consectetur tellus. Nunc vestibulum congue magna eget scelerisque. Nullam lobortis convallis justo vitae dignissim. Curabitur id massa mauris, sodales eleifend tortor. Duis non dignissim enim. Etiam vitae metus ac velit condimentum laoreet. Nullam viverra purus eleifend sem varius et mollis ipsum vestibulum. Sed sit amet velit velit, quis malesuada massa. Mauris sit amet ipsum diam, non porttitor orci. Cras ligula nibh, tincidunt mattis accumsan vitae, euismod at magna. Etiam nulla tellus, semper ac venenatis quis, dignissim quis nunc. Nulla sit amet arcu nisi. In at orci vitae nisi faucibus pretium eu sit amet eros.

Duis lacinia sollicitudin sagittis. Donec non velit sit amet ligula consequat ornare id id augue. Sed vestibulum, justo nec convallis feugiat, quam libero volutpat risus, eget posuere orci augue in felis. Duis vitae massa quis leo vestibulum blandit et vel lorem. Praesent est augue, vestibulum sit amet rhoncus at, cursus a mi. Cras quis lacus sit amet leo euismod adipiscing eget ac dolor. Donec posuere, odio ac semper faucibus, quam lectus ullamcorper est, et tempus lacus diam nec felis. Integer eget mauris eros. Mauris dolor turpis, sodales ut laoreet eu, aliquet et augue. Aenean sed felis et purus tincidunt iaculis a et risus. Etiam eu velit nisl. Donec volutpat urna mattis leo pellentesque faucibus. Nulla sit amet viverra enim. Quisque pulvinar odio ut nunc varius et volutpat erat pellentesque. Nulla volutpat porta auctor.

Fusce vel arcu mi. Proin eget nulla eu quam volutpat lobortis. Pellentesque vel odio eget sem aliquam venenatis. Fusce condimentum viverra sem id sollicitudin. Fusce sed pharetra mi. Cras at nisl nec dolor tristique lobortis et at dui. Nunc vitae magna id nulla lobortis rutrum ac vitae augue. Nam vehicula felis at dolor posuere a mollis lacus gravida. Proin nec dui vel odio auctor sodales at sed neque. Nam a augue sem. Nullam eget congue nisi. Aenean nibh nibh, rutrum vel pharetra sit amet, luctus quis mi.

Cras dapibus risus at tortor euismod ullamcorper. Praesent commodo ullamcorper felis, et vestibulum leo mattis sed. Donec bibendum diam tellus, non consequat diam. Vestibulum quam dui, semper non volutpat lobortis, molestie at libero. Phasellus egestas nunc nec justo viverra vitae interdum metus condimentum. Nulla ut accumsan ipsum. Nam ipsum magna, accumsan quis porta sed, ultricies sit amet tortor. Vestibulum lectus risus, feugiat et luctus non, facilisis ut nulla. Vivamus id lectus est, vitae pellentesque sem. Suspendisse purus arcu, dapibus sit amet congue sed, ultrices at diam. Suspendisse turpis quam, convallis ut volutpat sed, commodo non sem. Mauris vitae mi vitae magna luctus laoreet.

Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Aliquam et aliquam purus. Cras pretium purus ac magna interdum mattis in nec ipsum. Ut auctor sollicitudin enim porta consequat. Quisque vestibulum bibendum felis in semper. Aenean vitae quam quis est vulputate facilisis ut id urna. Pellentesque ut urna in libero condimentum rhoncus ut vel enim. Ut vitae tempor tellus. Phasellus molestie tortor eu lorem tincidunt tempor. Pellentesque dapibus, sem et sagittis ultrices, orci leo ultrices eros, ac hendrerit nulla mi eu velit. Donec ultricies dignissim nunc, et faucibus tortor fringilla eu. Fusce lacinia facilisis sapien, nec tempus augue tincidunt id. Mauris euismod neque vitae lectus molestie dapibus. Donec et elit eget quam pellentesque ullamcorper. Curabitur tempus risus a massa aliquam gravida. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Proin quis adipiscing massa. Mauris eu eros orci, vel elementum libero. Proin varius suscipit eleifend.
eof
  }
end
add_tags "foo", "some-very-very-very-very-long-tag"
