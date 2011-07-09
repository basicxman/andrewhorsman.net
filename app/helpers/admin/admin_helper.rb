module Admin::AdminHelper

  # Time to Commit string.
  def time_to_commit(article)
    return "Go" if article.stage == get_config(:required_milestone_commits) and article.published_at.nil?
    return "N/A" unless article.published_at.nil?
    time_required(article.last_commit_date)
  end

  # Calculate amount of time until a commit can be made.
  def time_required(time)
    target_time = time + get_config(:required_commit_time_delta).hours
    time_ago_in_words(target_time)
  end

  # Get the path to display an article.
  def preview(article)
    unless article.published_at.nil?
      article_path(article)
    else
      preview_path(article.preview_hash)
    end
  end

end
