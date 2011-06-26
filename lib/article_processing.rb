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
      content = add_tooltips(content)
    end

    # HTML renders multiple spaces not within a <pre> tag as a single space,
    # add literal "&nbsp;"s with a .tab span warpper.
    def indentation(content)
      content.gsub("  ", "<span class='tab'>&nbsp;&nbsp;</span>")
    end

    # Markdown blockquotes breaklines are annoying, add a blank ">\n" to every >
    def blockquote_fix(content)
      content.gsub!(/^>.*?\n/) { |m| "#{m}>\n" }
      content.gsub /(>\r?\n){3}/, "><br /><br />\n"
    end

    # Translate <tooltip> tags into something that actually works in a browser.
    def add_tooltips(content)
      content.gsub(/\<tooltip title="(.+?)"\>(.+?)\<\/tooltip\>/m) do
        "<span class='tooltip'><span class='tooltip-regular'>#{$2}</span><span class='tooltip-full'>#{$1}</span></span>"
      end
    end

    # Add syntax highlighting.
    def syntax_highlight(content)
      content.gsub(/\<code( lang="(.+?)")?\>(.+?)\<\/code\>/m) do
        "<div class='syntax'>" + pygmentize($3, ($2 || :text).to_sym) + "</div>"
      end
    end

    # Syntax highlight with Albino.
    def pygmentize(code, lang)
      code = process_code(code)
      a = Albino.new(code[:code], lang, :html)
      a.colorize(:O => "linenos=table", :P => "hl_lines=#{code[:lines]}")
    end

    # Parse code for things like highlighted lines.
    def process_code(code)
      line_numbers = []
      code.strip!
      code.split("\n").each_with_index do |line, index|
        line_numbers << index + 1 if line =~ /\*{3}(\r|\n|$)/
      end

      { :code => code.gsub(/\s*\*{3}(\r?\n|$)/, "\n"), :lines => line_numbers.join(",") }
    end

  end

end
