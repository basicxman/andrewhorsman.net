module TagsHelper

  def display_tag(tag)
    link_to tag.keyword, tag_path(tag), :title => tag.keyword
  end

end
