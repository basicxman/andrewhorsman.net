require 'test_helper'

class ArticleProcessingTest < ActiveSupport::TestCase
  test "should process an input file and return proper data" do
    file = <<-eof
@title: Testing!
@author: John Smith
@tags: testing this

ohi.
eof
    actual = ArticleProcessing.process_input_file(file)
    assert_equal "Testing!", actual[:title]
    assert_equal "John Smith", actual[:author]
    assert_equal "testing this", actual[:tag_list]
    assert_equal "ohi.", actual[:content]
  end

  test "should process an incomplete input file and still return proper data" do
    file = <<-eof
@title: Testing!

ohi.
eof
    actual = ArticleProcessing.process_input_file(file)
    assert_equal "Testing!", actual[:title]
    assert_equal "ohi.", actual[:content]
    assert_blank actual[:author]
  end

  test "should still return content if a file with no header tags is given" do
    file = <<-eof
ohi.
eof
    actual = ArticleProcessing.process_input_file(file)
    assert_equal "ohi.", actual[:content]
    assert_blank actual[:title]
  end

  test "should process plain content without errors" do
    assert_equal "<p>Testing</p>", ArticleProcessing.process_content("Testing")
  end

  test "should process a blockquote" do
    doc = get_doc("> Testing")
    assert_equal "Testing", doc.css("blockquote").text.strip
  end

  test "should allow for two individual consecutive blockquotes" do
    string = <<-eof
> Testing
> this!

<br />

> test!
eof

    doc = get_doc(string)
    assert_equal 2, doc.css("blockquote").length
    assert_equal 0, doc.css("blockquote blockquote").length
  end

  test "should highlight a snippet of code without a language specified" do
    string = <<-eof
```
puts "ohi!"
```
eof

    doc = get_doc(string)
    assert_equal 1, doc.css("pre code").length
    assert_equal 'puts "ohi!"', doc.css("pre code").text.strip
  end

  test "should highlight a snippet of code with a language specified" do
    string = <<-eof
``` ruby
puts "ohi!"
```
eof

    doc = get_doc(string)
    assert_equal 1, doc.css(".syntax").length
    assert_equal 1, doc.css(".highlighttable").length
    assert_equal 1, doc.css(".nb").length
  end

  test "should create tooltips" do
    string = <<-eof
<tooltip title="The tip.">The text.</tooltip>
eof

    doc = get_doc(string)
    assert_equal 0, doc.css("tooltip").length
    assert_equal "The text.", doc.css(".tooltip .tooltip-regular").text.strip
    assert_equal "The tip.",  doc.css(".tooltip .tooltip-full").text.strip
  end

  test "should highlight lines" do
    string = <<-eof
``` ruby
puts "ohi!" # this line prints something! ***
puts "orly?"
puts "yes!" # this line ALSO prints something! ***
```
eof
    doc = get_doc(string)
    hll = doc.css(".hll")
    assert_equal 2, hll.length
    assert_equal "puts \"ohi!\" # this line prints something!", hll.first.text.strip
    assert_equal "puts \"yes!\" # this line ALSO prints something!", hll.last.text.strip
  end

  private
  
  def get_doc(content)
    actual = ArticleProcessing.process_content(content)
    Nokogiri::HTML(actual)
  end
end
