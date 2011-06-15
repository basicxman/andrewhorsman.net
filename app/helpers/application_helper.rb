module ApplicationHelper

  def get_config(sym)
    Site::Application.config.send(sym)
  end

  def construct_title(title = nil)
    a = if title.blank?
      get_config(:main_title)
    else
      "#{title} | #{get_config(:main_title)}"
    end
    content_for :title, a
  end

  def add_header(title)
    construct_title(title)
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
