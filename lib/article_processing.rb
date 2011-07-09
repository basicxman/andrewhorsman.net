class ArticleProcessing; end

class << ArticleProcessing
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

    return { :content => data.strip } if header == data

    title   = header_var(header, "title")
    author  = header_var(header, "author")
    tags    = header_var(header, "tags")
    content = contents[index + 1..-1].join("\n")

    { :title => title, :author => author, :tag_list => tags, :content => content }
  end

  def process_content(content)
    content = Redcarpet.new(content, :hard_wrap, :gh_blockcode, :fenced_code, :autolink, :no_intraemphasis).to_html

    doc = ComplexProcessor.new(content)
    doc.highlight!
    doc.tooltips!

    doc.content
  end
end

# Abstract Nokogiri related processing.
class ComplexProcessor
  def initialize(content)
    @doc = Nokogiri::HTML::DocumentFragment.parse(content)
  end

  # Return content for further processing.
  def content
    @doc.inner_html
  end

  # Add syntax highlighting.
  def highlight!
    @doc.css("pre[@lang]").each do |pre|
      pre.replace "<div class='syntax'>" + pygmentize(pre.text.rstrip, pre.attr("lang")) + "</div>"
    end
  end

  # Translate <tooltip> tags into something that actually works in a browser.
  def tooltips!
    @doc.css("tooltip").each do |tip|
      tip.replace "<span class='tooltip'><span class='tooltip-regular'>#{tip.text.rstrip}</span><span class='tooltip-full'>#{tip.attr("title")}</span></span>"
    end
  end

  private

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
    code[0...6] = '' if code[0...6] == '<code>'
    code[-7, 7] = '' if code[-7, 7] == '</code>'
    code.split("\n").each_with_index do |line, index|
      line_numbers << index + 1 if line.end_with? "***"
    end

    { :code => code.gsub(/\s*\*{3}(\r?\n|$)/, "\n"), :lines => line_numbers.join(" ") }
  end
end
