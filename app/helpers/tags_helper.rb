module TagsHelper

  def display_tag(tag)
    link_to tag.keyword, tag_path(tag), :title => tag.keyword
  end

	def generate_tagline(tags)
    tagline = ""
    tags.each_with_index do |keyword, index|
      tagline += if index == 0
        keyword
      elsif index == tags.length - 1
        " and #{keyword}"
      else
        ", #{keyword}"
      end
    end
    tagline
  end

end
