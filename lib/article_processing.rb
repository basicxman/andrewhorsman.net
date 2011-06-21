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
      content = indentation(content)
    end

    def indentation(content)
      content.gsub("  ", "&nbsp;&nbsp;")
    end

  end

end
