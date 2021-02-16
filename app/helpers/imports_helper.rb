module ImportsHelper
  def refresh_file(import)
    Source.where(filename: import.filename).first.update(status: "in_progress")
  end
end
