class ArticleProcessing

  class << self

    def header_var(string, var)
      m = string.match(/^@#{var}:\s*(.*)$/)
      m.nil?? "" : m[1]
    end

    def process_input_file(data)
      contents = data.split("\n")
      header   = ""
      index    = 0
      contents.each do |line|
        break if line.blank?
        header += line + "\n"
        index += 1
      end

      title   = header_var(header, "title")
      author  = header_var(header, "author")
      tags    = header_var(header, "tags")
      content = contents[index + 1..-1].join("\n")

      { :title => title, :author => author, :tag_list => tags, :content => content }
    end

    def process_content(content)
      content = syntax_highlight(content)
      content = blockquote_fix(content)
      content = RDiscount.new(content, :smart).to_html
      content = indentation(content)
    end

    def indentation(content)
      content.gsub("  ", "<span class='tab'>&nbsp;&nbsp;</span>")
    end

    def blockquote_fix(content)
      content.gsub(/^>.*?\n/) { |m| "#{m}>\n" }
    end

    def syntax_highlight(content)
      content.gsub(/\<code( lang="(.+?)")?\>(.+?)\<\/code\>/m) do
        CodeRay.scan($3, $2).div(:css => :class, :line_numbers => :table)
      end
    end

  end

end
