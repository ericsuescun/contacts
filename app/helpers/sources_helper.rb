module SourcesHelper
  def set_source_filename(user_id, filename)
    user = User.find(user_id)
    user.sources.create(
      order: nil,
      filename: filename,
      status: "pending"
      )
  end
end
