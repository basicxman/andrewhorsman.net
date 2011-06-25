module Admin::AdminHelper

  # Calculate amount of time until a commit can be made.
  def time_required(time)
    return "Go" if time.nil?
    target_time = time + get_config(:required_commit_time_delta).hours

    time_ago_in_words(target_time)
  end

end
