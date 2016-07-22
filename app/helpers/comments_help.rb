module CommentsHelp
  def json_data comment
    data = Hash.new
    data[:id] = comment.id
    data[:image_url] = comment.user_avatar.url
    data[:user_name] = comment.user_name
    data[:content] = comment.content
    data[:time] = comment.created_at
    data[:rating] = comment.rating
    return data
  end
end
