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

end
