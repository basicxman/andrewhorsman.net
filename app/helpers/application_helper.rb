module ApplicationHelper

  def get_config(sym)
    Site::Application.config.send(sym)
  end

  def construct_title(title = nil)
    return get_config(:main_title) if title.blank?
    "#{title} | #{get_config(:main_title)}"
  end

  def add_header(title)
    content_for :title, title
    "<h3>#{title}</h3>".html_safe
  end

  def error_for(sym, model, extra = "")
    if model.errors[sym].length > 0
      "<span class='field-error'>#{model.errors[sym].first}</span>#{extra}".html_safe
    end
  end

  def snip_content(content)
    return content if content.length <= get_config(:short_content_length)
    content[0..get_config(:short_content_length)] + "..."
  end

  def snip_column_content(content)
    return content if content.length <= get_config(:short_column_content_length)
    content[0..get_config(:short_column_content_length)] + "..."
  end

end
