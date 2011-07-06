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

  # Smarter content snipping.
  def snip_content(content)
    c = content.gsub(/\<div class="syntax"\>.*?\<\/table\>\<\/div\>/m, "") # Remove large syntax highlighted regions.
    l = get_config(:short_content_length)
    return c if c.length <= l

    i = l + c[l..-1].index(/[!\?\.;,\s%]|$/)
    i = l if i.nil? or i - 15 > l
    c[0...i] + "..."
  end

  # Social buttons.
  def social_image(network)
    image_tag(asset_path("social/#{network}_button.png"), :alt => "Share on #{network.capitalize}")
  end

end
